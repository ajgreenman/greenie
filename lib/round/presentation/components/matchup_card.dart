import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/round/infrastructure/models/models.dart';
import 'package:greenie/round/round_providers.dart';

class MatchupCard extends ConsumerWidget {
  const MatchupCard({
    super.key,
    required this.matchup,
    required this.roundId,
    required this.leagueId,
  });

  final MatchupModel matchup;
  final String roundId;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultAsync = ref.watch(
      fetchMatchupResultProvider(roundId, matchup.id),
    );
    final theme = Theme.of(context);

    return switch (resultAsync) {
      AsyncData(:final value) => _MatchupCardContent(
        result: value,
        onTap: () => context.go(
          '/league/$leagueId/round/$roundId/matchup/${matchup.id}',
        ),
      ),
      AsyncError() => const SizedBox.shrink(),
      _ => Card(
        child: Padding(
          padding: const EdgeInsets.all(GreenieSizes.large),
          child: Row(
            children: [
              const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              const SizedBox(width: GreenieSizes.small),
              Text('Loading matchup…', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    };
  }
}

class _MatchupCardContent extends StatelessWidget {
  const _MatchupCardContent({required this.result, required this.onTap});

  final MatchupResult result;
  final VoidCallback onTap;

  String _formatPts(double pts) {
    if (pts == pts.truncateToDouble()) return pts.toInt().toString();
    return pts.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final t1pts = result.team1GrandTotal;
    final t2pts = result.team2GrandTotal;
    final isComplete = result.holeResults.length == 9;

    Color chipColor(MatchupOutcome outcome) => switch (outcome) {
      MatchupOutcome.win => theme.colorScheme.primary,
      MatchupOutcome.loss => theme.colorScheme.error,
      MatchupOutcome.tie => theme.colorScheme.secondary,
    };

    String chipLabel(MatchupOutcome outcome) => switch (outcome) {
      MatchupOutcome.win => 'W',
      MatchupOutcome.loss => 'L',
      MatchupOutcome.tie => 'T',
    };

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(GreenieSizes.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: GreenieSizes.small,
            children: [
              Row(
                children: [
                  Text('Your Matchup', style: theme.textTheme.labelMedium),
                  const Spacer(),
                  if (isComplete)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: GreenieSizes.small,
                        vertical: GreenieSizes.extraSmall,
                      ),
                      decoration: BoxDecoration(
                        color: chipColor(result.team1Outcome),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        chipLabel(result.team1Outcome),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      result.team1.name,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    '${_formatPts(t1pts)} – ${_formatPts(t2pts)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      result.team2.name,
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    '${result.holeResults.length} holes',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.chevron_right,
                    size: GreenieSizes.large,
                    color: theme.colorScheme.outline,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
