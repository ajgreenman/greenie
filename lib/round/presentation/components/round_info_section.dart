import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';

class RoundInfoSection extends ConsumerWidget {
  const RoundInfoSection({super.key, required this.round});

  final RoundModel round;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courseAsync = ref.watch(fetchCourseProvider(round.courseId));
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(switch (courseAsync) {
              AsyncData(:final value) => value?.name ?? 'Unknown Course',
              _ => '...',
            }, style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(round.date.displayDate, style: theme.textTheme.bodySmall),
                const SizedBox(width: 16),
                Icon(Icons.flag, size: 16, color: theme.colorScheme.outline),
                const SizedBox(width: 4),
                Text(
                  'Holes ${round.holeNumbers.first}-${round.holeNumbers.last}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
