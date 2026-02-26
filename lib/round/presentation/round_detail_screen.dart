import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/presentation/components/scorecard.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/presentation/components/matchup_card.dart';
import 'package:greenie/round/presentation/components/round_info_section.dart';
import 'package:greenie/round/presentation/components/round_leaderboard.dart';
import 'package:greenie/round/presentation/components/start_round_button.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/user_providers.dart';

class RoundDetailScreen extends ConsumerWidget {
  const RoundDetailScreen({
    super.key,
    required this.leagueId,
    required this.roundId,
  });

  final String leagueId;
  final String roundId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundAsync = ref.watch(fetchRoundProvider(roundId));
    return Scaffold(
      appBar: AppBar(title: const Text('Round')),
      body: switch (roundAsync) {
        AsyncData(:final value) when value != null => SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              RoundInfoSection(round: value),
              const SizedBox(height: 16),
              _MatchupSection(round: value, leagueId: leagueId),
              if (value.scores.isNotEmpty) ...[
                RoundLeaderboard(round: value, leagueId: leagueId),
                const SizedBox(height: 16),
                _ReadOnlyScorecard(round: value, leagueId: leagueId),
                const SizedBox(height: 16),
              ],
              if (value.status == RoundStatus.upcoming)
                StartRoundButton(
                  label: 'Start Round',
                  onPressed: () =>
                      context.go('/league/$leagueId/round/$roundId/scorecard'),
                ),
              if (value.status == RoundStatus.inProgress)
                StartRoundButton(
                  label: 'Continue Round',
                  onPressed: () =>
                      context.go('/league/$leagueId/round/$roundId/scorecard'),
                ),
            ],
          ),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

/// Shows [MatchupCard] for the current user's matchup in this round, if any.
class _MatchupSection extends ConsumerWidget {
  const _MatchupSection({required this.round, required this.leagueId});

  final RoundModel round;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(fetchLeagueProvider(leagueId));
    final userAsync = ref.watch(currentUserProvider);

    final league = switch (leagueAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };
    final user = switch (userAsync) {
      AsyncData(:final value) => value,
      _ => null,
    };

    if (league == null || user == null) return const SizedBox.shrink();

    // Find the current user's team
    final userTeam = league.teams
        .where((t) => t.memberIds.contains(user.memberId))
        .firstOrNull;
    if (userTeam == null) return const SizedBox.shrink();

    // Find their matchup this round
    MatchupModel? userMatchup;
    for (final m in round.matchups) {
      if (m.team1Id == userTeam.id || m.team2Id == userTeam.id) {
        userMatchup = m;
        break;
      }
    }
    if (userMatchup == null) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: MatchupCard(
        matchup: userMatchup,
        roundId: round.id,
        leagueId: leagueId,
      ),
    );
  }
}

class _ReadOnlyScorecard extends ConsumerWidget {
  const _ReadOnlyScorecard({required this.round, required this.leagueId});

  final RoundModel round;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(fetchCourseProvider(round.courseId));
    final membersAsync = ref.watch(fetchMembersProvider(leagueId));

    return switch ((courseAsync, membersAsync)) {
      (AsyncData(:final value), AsyncData(value: final members))
          when value != null =>
        Scorecard(round: round, course: value, members: members),
      _ => const SizedBox.shrink(),
    };
  }
}
