import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/round/infrastructure/models/models.dart';

class UpcomingRoundCard extends ConsumerWidget {
  const UpcomingRoundCard({
    super.key,
    required this.round,
    required this.leagueId,
  });

  final RoundModel round;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(fetchCourseProvider(round.courseId));
    final isInProgress = round.status == RoundStatus.inProgress;
    final theme = Theme.of(context);

    final headerColor = isInProgress
        ? const Color(0xFFE65100)
        : theme.colorScheme.primary;
    final label = isInProgress ? 'Round In Progress' : 'Next Round';

    final courseName = switch (courseAsync) {
      AsyncData(:final value) => value?.name ?? 'Unknown',
      _ => '...',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: GreenieSizes.large),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.go('/league/$leagueId/round/${round.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: headerColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: GreenieSizes.large,
                  vertical: GreenieSizes.medium,
                ),
                child: Row(
                  children: [
                    Icon(
                      isInProgress ? Icons.sports_golf : Icons.event,
                      color: Colors.white,
                      size: GreenieSizes.large,
                    ),
                    const SizedBox(width: GreenieSizes.small),
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.chevron_right, color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(GreenieSizes.large),
                child: Row(
                  spacing: GreenieSizes.extraLarge,
                  children: [
                    _InfoChip(
                      icon: Icons.calendar_today,
                      label: round.date.displayDate,
                    ),
                    _InfoChip(
                      icon: Icons.golf_course,
                      label: courseName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      spacing: GreenieSizes.extraSmall,
      children: [
        Icon(icon, size: GreenieSizes.large, color: theme.colorScheme.outline),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
