import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenie/app/core/theme/sizes.dart';
import 'package:greenie/round/infrastructure/infrastructure.dart';
import 'package:greenie/user/infrastructure/infrastructure.dart';
import 'package:greenie/user/user_providers.dart';

class RoundLeaderboard extends ConsumerStatefulWidget {
  const RoundLeaderboard({
    super.key,
    required this.round,
    required this.leagueId,
  });

  final RoundModel round;
  final String leagueId;

  @override
  ConsumerState<RoundLeaderboard> createState() => _RoundLeaderboardState();
}

class _RoundLeaderboardState extends ConsumerState<RoundLeaderboard> {
  bool _showNet = false;

  int _netTotal(ScoreModel score, int handicap, List<int> holeNumbers) {
    final strokes = calculateHandicapStrokes(handicap, holeNumbers);
    return score.holeScores.entries
        .where((e) => holeNumbers.contains(e.key))
        .fold(0, (sum, e) => sum + netScore(e.value, strokes[e.key] ?? 0));
  }

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(fetchMembersProvider(widget.leagueId));
    final theme = Theme.of(context);

    final members = switch (membersAsync) {
      AsyncData(:final value) => value,
      _ => <MemberModel>[],
    };

    MemberModel? findMember(String memberId) =>
        members.where((m) => m.id == memberId).firstOrNull;

    final sorted = [...widget.round.scores];
    if (_showNet) {
      sorted.sort((a, b) {
        final aHandicap = findMember(a.userId)?.handicap ?? 0;
        final bHandicap = findMember(b.userId)?.handicap ?? 0;
        final aNet = _netTotal(a, aHandicap, widget.round.holeNumbers);
        final bNet = _netTotal(b, bHandicap, widget.round.holeNumbers);
        return aNet.compareTo(bNet);
      });
    } else {
      sorted.sort((a, b) => a.totalStrokes.compareTo(b.totalStrokes));
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GreenieSizes.large),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: GreenieSizes.small),
              child: Text('Leaderboard', style: theme.textTheme.titleSmall),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: GreenieSizes.small),
                child: SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(value: false, label: Text('Gross')),
                    ButtonSegment(value: true, label: Text('Net')),
                  ],
                  selected: {_showNet},
                  onSelectionChanged: (selected) =>
                      setState(() => _showNet = selected.first),
                  style: const ButtonStyle(
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ),
            ...sorted.asMap().entries.map((entry) {
              final rank = entry.key + 1;
              final score = entry.value;
              final member = findMember(score.userId);
              final memberName = member?.name;
              final initials = member?.initials ?? '??';
              final handicap = member?.handicap ?? 0;
              final displayScore = _showNet
                  ? _netTotal(score, handicap, widget.round.holeNumbers)
                  : score.totalStrokes;
              return Column(
                children: [
                  if (rank > 1) const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: GreenieSizes.small,
                    ),
                    child: Row(
                      spacing: GreenieSizes.small,
                      children: [
                        SizedBox(
                          width: 28,
                          child: Text(
                            '$rank',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        CircleAvatar(child: Text(initials)),
                        Expanded(child: Text(memberName ?? score.userId)),
                        Text(
                          '$displayScore',
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
