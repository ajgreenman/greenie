import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/league/presentation/components/components.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';
import 'package:greenie/user/user_model.dart';
import 'package:greenie/user/user_providers.dart';

class StatsScreen extends ConsumerStatefulWidget {
  const StatsScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  ConsumerState<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends ConsumerState<StatsScreen> {
  bool _showLeague = false;

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final membersAsync = ref.watch(fetchMembersProvider(widget.leagueId));
    final roundsAsync = ref.watch(
      fetchRoundsForLeagueProvider(widget.leagueId),
    );

    Widget body;

    if (userAsync case AsyncError(:final error)) {
      body = Center(child: Text('Error: $error'));
    } else if (membersAsync case AsyncError(:final error)) {
      body = Center(child: Text('Error: $error'));
    } else if (roundsAsync case AsyncError(:final error)) {
      body = Center(child: Text('Error: $error'));
    } else if (!userAsync.hasValue ||
        !membersAsync.hasValue ||
        !roundsAsync.hasValue) {
      body = const Center(child: CircularProgressIndicator());
    } else {
      body = _buildBody(
        context,
        user: userAsync.requireValue,
        members: membersAsync.requireValue,
        rounds: roundsAsync.requireValue,
      );
    }

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 0) context.go('/league/${widget.leagueId}');
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
      appBar: AppBar(
        title: const Text('Stats'),
        actions: [
          IconButton(
            onPressed: () => context.go('/league/${widget.leagueId}/settings'),
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: body,
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required UserModel user,
    required List<MemberModel> members,
    required List<RoundModel> rounds,
  }) {
    final memberId = user.id;

    final myRounds =
        rounds
            .where(
              (r) =>
                  r.status == RoundStatus.completed &&
                  r.scores.any((s) => s.userId == memberId),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final myMember = members.where((m) => m.id == memberId).firstOrNull;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(GreenieSizes.large),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Personal')),
                ButtonSegment(value: true, label: Text('League')),
              ],
              selected: {_showLeague},
              onSelectionChanged: (s) => setState(() => _showLeague = s.first),
            ),
          ),
          if (!_showLeague)
            _PersonalStats(
              myRounds: myRounds,
              myMember: myMember,
              userId: memberId,
            )
          else
            const EmptyState(
              icon: Icons.bar_chart,
              message: 'League stats coming soon',
            ),
        ],
      ),
    );
  }
}

class _PersonalStats extends StatelessWidget {
  const _PersonalStats({
    required this.myRounds,
    required this.myMember,
    required this.userId,
  });

  final List<RoundModel> myRounds;
  final MemberModel? myMember;
  final String? userId;

  @override
  Widget build(BuildContext context) {
    final myScores = myRounds
        .map(
          (r) =>
              r.scores.firstWhere((s) => s.userId == userId).totalStrokes,
        )
        .toList();

    final String avgScore;
    final String bestRound;
    if (myScores.isEmpty) {
      avgScore = '-';
      bestRound = '-';
    } else {
      final sum = myScores.reduce((a, b) => a + b);
      final avg = sum / myScores.length;
      avgScore = avg == avg.roundToDouble()
          ? avg.round().toString()
          : avg.toStringAsFixed(1);
      bestRound = myScores.reduce((a, b) => a < b ? a : b).toString();
    }

    final recentRounds = myRounds.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: GreenieSizes.large),
          child: GridView(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: GreenieSizes.small,
              crossAxisSpacing: GreenieSizes.small,
              childAspectRatio: 1.6,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              StatCard(
                label: 'Rounds Played',
                value: myRounds.length.toString(),
              ),
              StatCard(label: 'Avg Score', value: avgScore),
              StatCard(label: 'Best Round', value: bestRound),
              StatCard(
                label: 'Handicap',
                value: myMember?.handicap.toString() ?? '-',
              ),
            ],
          ),
        ),
        const SectionHeader(title: 'Recent Rounds'),
        if (recentRounds.isEmpty)
          const EmptyState(
            icon: Icons.flag_outlined,
            message: 'No completed rounds yet',
          )
        else
          ...recentRounds.map((r) {
            final score = r.scores
                .firstWhere((s) => s.userId == userId)
                .totalStrokes;
            return ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(r.date.displayDate),
              trailing: Text(
                score.toString(),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            );
          }),
      ],
    );
  }
}
