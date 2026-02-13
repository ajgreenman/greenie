import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme.dart';
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
        padding: const EdgeInsets.all(large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: small,
          children: [
            Text(switch (courseAsync) {
              AsyncData(:final value) => value?.name ?? 'Unknown Course',
              _ => '...',
            }, style: theme.textTheme.titleMedium),
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: extraSmall),
                  child: Text(
                    round.date.displayDate,
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: large),
                  child: Icon(
                    Icons.flag,
                    size: 16,
                    color: theme.colorScheme.outline,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: extraSmall),
                  child: Text(
                    'Holes ${round.holeNumbers.first}-${round.holeNumbers.last}',
                    style: theme.textTheme.bodySmall,
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
