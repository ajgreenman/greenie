import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/league/presentation/components/preview_table.dart';
import 'package:greenie/user/infrastructure/models/models.dart';

class MembersPreview extends StatelessWidget {
  const MembersPreview({
    super.key,
    required this.members,
    required this.userMemberId,
    required this.leagueId,
  });

  final List<MemberModel> members;
  final String? userMemberId;
  final String leagueId;

  /// Members ranked by handicap ascending (lower = better). Ties broken
  /// alphabetically by name.
  List<MemberModel> _sorted() => [...members]..sort(
    (a, b) => a.handicap != b.handicap
        ? a.handicap.compareTo(b.handicap)
        : a.name.compareTo(b.name),
  );

  List<(int rank, MemberModel member)> _previewRows(
    List<MemberModel> sorted,
  ) {
    final ranked = [
      for (var i = 0; i < sorted.length; i++) (i + 1, sorted[i]),
    ];

    if (ranked.length <= 3) return ranked;

    final userIndex = sorted.indexWhere((m) => m.id == userMemberId);
    if (userIndex <= 0) return ranked.sublist(0, 3);
    if (userIndex >= sorted.length - 1) return ranked.sublist(sorted.length - 3);
    return ranked.sublist(userIndex - 1, userIndex + 2);
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted();
    final preview = _previewRows(sorted);

    return PreviewTable(
      columns: const [
        PreviewColumn(
          label: '#',
          width: 32,
          style: PreviewCellStyle.rank,
        ),
        PreviewColumn(
          label: 'Player',
          flex: 1,
          style: PreviewCellStyle.name,
        ),
        PreviewColumn(
          label: 'Hdcp',
          width: 48,
          alignment: TextAlign.end,
          style: PreviewCellStyle.value,
        ),
      ],
      rows: preview
          .map(
            (r) => PreviewRow(
              cells: ['#${r.$1}', r.$2.name, r.$2.handicap.toString()],
              isHighlighted: r.$2.id == userMemberId,
              onTap: () => context.go('/league/$leagueId/members'),
            ),
          )
          .toList(),
      viewAllLabel: 'All Members',
      onViewAll: () => context.go('/league/$leagueId/members'),
    );
  }
}
