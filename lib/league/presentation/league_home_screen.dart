import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/section_header.dart';
import 'package:greenie/league/league_providers.dart';
import 'package:greenie/league/presentation/components/league_info_header.dart';
import 'package:greenie/league/presentation/components/members_preview.dart';
import 'package:greenie/league/presentation/components/rounds_preview.dart';
import 'package:greenie/league/presentation/components/standings_preview.dart';
import 'package:greenie/league/presentation/components/upcoming_round_card.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/user_providers.dart';

enum _MenuAction { settings, admin }

class LeagueHomeScreen extends ConsumerWidget {
  const LeagueHomeScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final leagueAsync = ref.watch(fetchLeagueProvider(leagueId));
    final roundsAsync = ref.watch(fetchRoundsForLeagueProvider(leagueId));
    final userAsync = ref.watch(currentUserProvider);
    final standingsAsync = ref.watch(fetchStandingsProvider(leagueId));
    final membersAsync = ref.watch(fetchMembersProvider(leagueId));

    final memberId = switch (userAsync) {
      AsyncData(value: final u) => u.memberId,
      _ => '',
    };
    final isAdmin = switch ((userAsync, leagueAsync)) {
      (AsyncData(value: final u), AsyncData(value: final league)) =>
        u.id == league.adminId,
      _ => false,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(leagueAsync.hasValue ? leagueAsync.value!.name : ''),
        leading: IconButton(
          onPressed: () => context.go('/'),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          PopupMenuButton<_MenuAction>(
            icon: const Icon(Icons.settings),
            onSelected: (action) {
              switch (action) {
                case _MenuAction.settings:
                  context.go('/league/$leagueId/settings');
                case _MenuAction.admin:
                  context.go('/league/$leagueId/admin');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: _MenuAction.settings,
                child: Text('Settings'),
              ),
              if (isAdmin)
                const PopupMenuItem(
                  value: _MenuAction.admin,
                  child: Text('Admin'),
                ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) context.go('/league/$leagueId/stats');
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'League',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
        ],
      ),
      body: switch (leagueAsync) {
        AsyncData(value: final league) => SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: GreenieSizes.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GreenieSizes.large,
            children: [
              LeagueInfoHeader(league: league),
              if (roundsAsync case AsyncData(value: final rounds))
                ...() {
                  final upcoming =
                      rounds
                          .where(
                            (r) =>
                                r.status == RoundStatus.upcoming ||
                                r.status == RoundStatus.inProgress,
                          )
                          .toList()
                        ..sort((a, b) => a.date.compareTo(b.date));
                  return upcoming.isNotEmpty
                      ? [
                          UpcomingRoundCard(
                            round: upcoming.first,
                            leagueId: leagueId,
                          ),
                        ]
                      : <Widget>[];
                }(),
              if (standingsAsync case AsyncData(
                value: final standings,
              ) when standings.isNotEmpty) ...[
                const SectionHeader(title: 'Standings'),
                StandingsPreview(
                  standings: standings,
                  userMemberId: memberId,
                  league: league,
                  leagueId: leagueId,
                ),
              ],
              if (roundsAsync case AsyncData(value: final rounds))
                if (memberId.isNotEmpty &&
                    rounds.any(
                      (r) =>
                          r.status == RoundStatus.completed &&
                          r.scores.any((s) => s.memberId == memberId),
                    )) ...[
                  const SectionHeader(title: 'Recent Rounds'),
                  RoundsPreview(
                    rounds: rounds,
                    memberId: memberId,
                    leagueId: leagueId,
                  ),
                ],
              if (membersAsync case AsyncData(
                value: final members,
              ) when members.isNotEmpty) ...[
                const SectionHeader(title: 'Members'),
                MembersPreview(
                  members: members,
                  userMemberId: memberId,
                  leagueId: leagueId,
                ),
              ],
            ],
          ),
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}
