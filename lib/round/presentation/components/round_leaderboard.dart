import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/design_constants.dart';
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
        padding: const EdgeInsets.all(large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: small),
              child: Text('Leaderboard', style: theme.textTheme.titleSmall),
            ),
            ...sorted.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final score = entry.value;
              final member = switch (membersAsync) {
                AsyncData(:final value) =>
                  value.where((m) => m.id == score.memberId).firstOrNull,
                _ => null,
              };
              final memberName = member?.name;
              final initials = member?.initials ?? '??';
              return Column(
                children: [
                  if (rank > 1) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: small),
                    child: Row(
                      children: [
                        SizedBox(
                          width: leaderboardRankWidth,
                          child: Text(
                            '$rank',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CircleAvatar(
                          radius: avatarRadius,
                          child: Text(initials),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: small),
                            child: Text(memberName ?? score.memberId),
                          ),
                        ),
                        Text(
                          '${score.totalStrokes}',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
