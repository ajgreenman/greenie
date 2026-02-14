import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
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
    final isInProgress = round.status == RoundStatus.inProgress;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: large),
      child: FilledButton(
        onPressed: () => context.go('/league/$leagueId/round/${round.id}'),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 2,
                children: [
                  Text(
                    isInProgress ? 'Round In Progress' : 'Next Round',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        round.date.displayDate,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(Icons.circle, size: 4),
                      ),
                      Text(switch (courseAsync) {
                        AsyncData(:final value) => value?.name ?? 'Unknown',
                        _ => '...',
                      }, style: const TextStyle(fontSize: 13)),
                    ],
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
