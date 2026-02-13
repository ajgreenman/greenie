import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/design_constants.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/app/presentation/components/info_card.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';

class RoundListTile extends ConsumerWidget {
  const RoundListTile({super.key, required this.round, required this.leagueId});

  final RoundModel round;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(fetchCourseProvider(round.courseId));
    final theme = Theme.of(context);

    return InfoCard(
      onTap: () => context.go('/league/$leagueId/round/${round.id}'),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 2,
              children: [
                Text(switch (courseAsync) {
                  AsyncData(:final value) => value?.name ?? 'Unknown Course',
                  _ => '...',
                }, style: theme.textTheme.titleSmall),
                Text(
                  '${round.date.displayDate} \u2022 Holes ${round.holeNumbers.first}-${round.holeNumbers.last}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          _StatusChip(status: round.status),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final RoundStatus status;

  @override
  Widget build(BuildContext context) {
    final (color, bgColor) = switch (status) {
      RoundStatus.upcoming => (
        Theme.of(context).colorScheme.primary,
        Theme.of(context).colorScheme.primaryContainer,
      ),
      RoundStatus.inProgress => (
        Theme.of(context).colorScheme.tertiary,
        Theme.of(context).colorScheme.tertiaryContainer,
      ),
      RoundStatus.completed => (
        Theme.of(context).colorScheme.outline,
        Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    };
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: small,
        vertical: extraSmall,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(statusChipRadius),
      ),
      child: Text(
        status.displayName,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
