import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/app/presentation/components/components.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/round/round_providers.dart';

class AdminHubScreen extends ConsumerWidget {
  const AdminHubScreen({super.key, required this.leagueId});

  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roundsAsync = ref.watch(fetchRoundsForLeagueProvider(leagueId));

    return Scaffold(
      appBar: AppBar(title: const Text('Commissioner')),
      body: switch (roundsAsync) {
        AsyncData(:final value) when value.isEmpty => const EmptyState(
          icon: Icons.calendar_today,
          message: 'No rounds yet',
        ),
        AsyncData(:final value) => _RoundList(
          rounds: List.of(value)..sort((a, b) => b.date.compareTo(a.date)),
          leagueId: leagueId,
        ),
        AsyncError(:final error) => Center(child: Text('Error: $error')),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }
}

class _RoundList extends StatelessWidget {
  const _RoundList({required this.rounds, required this.leagueId});

  final List<RoundModel> rounds;
  final String leagueId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: GreenieSizes.large,
        vertical: GreenieSizes.large,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: GreenieSizes.medium,
        children: rounds.map((round) => _RoundCard(round: round, leagueId: leagueId)).toList(),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  const _RoundCard({required this.round, required this.leagueId});

  final RoundModel round;
  final String leagueId;

  String get _nineLabel {
    if (round.holeNumbers.isEmpty) return '';
    return round.holeNumbers.first <= 9 ? 'Front 9' : 'Back 9';
  }

  String get _statusLabel {
    return switch (round.status) {
      RoundStatus.upcoming => 'Upcoming',
      RoundStatus.inProgress => 'In Progress',
      RoundStatus.completed => 'Completed',
    };
  }

  Color _statusColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return switch (round.status) {
      RoundStatus.upcoming => cs.secondary,
      RoundStatus.inProgress => cs.primary,
      RoundStatus.completed => cs.outline,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GreenieSizes.medium),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: GreenieSizes.medium,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        round.date.displayDate,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_nineLabel.isNotEmpty)
                        Text(
                          _nineLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GreenieSizes.small,
                    vertical: GreenieSizes.extraSmall,
                  ),
                  decoration: BoxDecoration(
                    color: _statusColor(context).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(GreenieSizes.extraSmall),
                  ),
                  child: Text(
                    _statusLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _statusColor(context),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: GreenieSizes.small,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go(
                      '/league/$leagueId/admin/schedule/${round.id}',
                    ),
                    child: const Text('Set Schedule'),
                  ),
                ),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => context.go(
                      '/league/$leagueId/admin/scorecard/${round.id}',
                    ),
                    child: const Text('Correct Scores'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
