import 'package:flutter/material.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/course/presentation/components/hole_header_cell.dart';
import 'package:greenie/course/presentation/components/score_cell.dart';
import 'package:greenie/course/presentation/components/scorecard_row.dart';
import 'package:greenie/course/presentation/components/scorecard_totals.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/infrastructure/skins_calculator.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

class Scorecard extends StatelessWidget {
  const Scorecard({
    super.key,
    required this.round,
    required this.course,
    required this.members,
    this.isEditable = false,
    this.onScoreTap,
  });

  final RoundModel round;
  final CourseModel course;
  final List<MemberModel> members;
  final bool isEditable;
  final void Function(String memberId, int holeNumber)? onScoreTap;

  @override
  Widget build(BuildContext context) {
    final holes =
        course.holes.where((h) => round.holeNumbers.contains(h.number)).toList()
          ..sort((a, b) => a.number.compareTo(b.number));

    final skins = calculateSkins(round.scores, round.holeNumbers);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hole header row
          ScorecardRow(
            label: 'Hole',
            cells: holes
                .map((h) => HoleHeaderCell(holeNumber: h.number))
                .toList(),
            totalWidget: Text(
              'Tot',
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          const Divider(height: 1),
          // Par row
          ScorecardRow(
            label: 'Par',
            cells: holes
                .map(
                  (h) => Container(
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: Text(
                      '${h.par}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                )
                .toList(),
            totalWidget: ScorecardTotals(
              total: holes.fold(0, (sum, h) => sum + h.par),
            ),
          ),
          const Divider(height: 1),
          // Player score rows
          ...round.scores.map((score) {
            final member = members
                .where((m) => m.id == score.memberId)
                .firstOrNull;
            return Column(
              children: [
                ScorecardRow(
                  label: member?.name ?? score.memberId,
                  cells: holes.map((h) {
                    final strokes = score.holeScores[h.number];
                    return ScoreCell(
                      score: strokes,
                      par: h.par,
                      isEditable: isEditable,
                      onTap: onScoreTap != null
                          ? () => onScoreTap!(score.memberId, h.number)
                          : null,
                    );
                  }).toList(),
                  totalWidget: ScorecardTotals(
                    total: _playerTotal(score, holes),
                  ),
                ),
                const Divider(height: 1),
              ],
            );
          }),
          // Skins row
          ScorecardRow(
            label: 'Skins',
            cells: holes.map((h) {
              final winnerId = skins[h.number];
              final winner = winnerId != null
                  ? members.where((m) => m.id == winnerId).firstOrNull
                  : null;
              return Container(
                width: 36,
                height: 36,
                alignment: Alignment.center,
                child: Text(
                  winner?.initials ?? '-',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: winner != null ? FontWeight.bold : null,
                    color: winner != null
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  int _playerTotal(ScoreModel score, List<HoleModel> holes) {
    var total = 0;
    for (final h in holes) {
      final strokes = score.holeScores[h.number];
      if (strokes != null) total += strokes;
    }
    return total;
  }
}
