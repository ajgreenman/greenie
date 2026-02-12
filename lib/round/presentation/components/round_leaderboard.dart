import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/user/user_providers.dart';

class RoundLeaderboard extends ConsumerWidget {
  const RoundLeaderboard({
    super.key,
    required this.round,
    required this.leagueId,
  });

  final RoundModel round;
  final String leagueId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final membersAsync = ref.watch(fetchMembersProvider(leagueId));
    final theme = Theme.of(context);

    final sorted = [...round.scores]
      ..sort((a, b) => a.totalStrokes.compareTo(b.totalStrokes));

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Leaderboard', style: theme.textTheme.titleSmall),
            const SizedBox(height: 8),
            ...sorted.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final score = entry.value;
              final memberName = switch (membersAsync) {
                AsyncData(:final value) =>
                  value.where((m) => m.id == score.memberId).firstOrNull?.name,
                _ => null,
              };
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: Text(
                        '$rank',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(child: Text(memberName ?? score.memberId)),
                    Text(
                      '${score.totalStrokes}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
