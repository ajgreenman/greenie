import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';
import 'package:greenie/league/presentation/components/preview_table.dart';
import 'package:greenie/round/infrastructure/models/models.dart';

class RoundsPreview extends StatelessWidget {
  const RoundsPreview({
    super.key,
    required this.rounds,
    required this.userId,
    required this.leagueId,
  });

  final List<RoundModel> rounds;
  final String userId;
  final String leagueId;

  @override
  Widget build(BuildContext context) {
    final recent = rounds
        .where(
          (r) =>
              r.status == RoundStatus.completed &&
              r.scores.any((s) => s.userId == userId),
        )
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    final preview = recent.take(3).toList();

    return PreviewTable(
      columns: const [
        PreviewColumn(label: 'Date', flex: 1, style: PreviewCellStyle.name),
        PreviewColumn(
          label: 'Score',
          width: 48,
          alignment: TextAlign.end,
          style: PreviewCellStyle.value,
        ),
      ],
      rows: preview
          .map(
            (r) => PreviewRow(
              cells: [
                r.date.displayDate,
                r.scores
                    .firstWhere((s) => s.userId == userId)
                    .totalStrokes
                    .toString(),
              ],
              onTap: () => context.go('/league/$leagueId/round/${r.id}'),
            ),
          )
          .toList(),
      viewAllLabel: 'All Rounds',
      onViewAll: () => context.go('/league/$leagueId/rounds'),
    );
  }
}
