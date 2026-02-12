import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/app/presentation/components/info_card.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';

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
    final theme = Theme.of(context);
    final isInProgress = round.status == RoundStatus.inProgress;

    return InfoCard(
      onTap: () => context.go('/league/$leagueId/round/${round.id}'),
      child: Row(
        children: [
          Icon(
            isInProgress ? Icons.play_circle : Icons.event,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isInProgress ? 'Round In Progress' : 'Next Round',
                  style: theme.textTheme.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '${round.date.displayDate} \u2022 ${switch (courseAsync) {
                    AsyncData(:final value) => value?.name ?? 'Unknown',
                    _ => '...',
                  }}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
