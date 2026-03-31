import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenie/league/infrastructure/models/models.dart';
import 'package:greenie/league/presentation/components/preview_table.dart';

class StandingsPreview extends StatelessWidget {
  const StandingsPreview({
    super.key,
    required this.standings,
    required this.userMemberId,
    required this.league,
    required this.leagueId,
  });

  final List<TeamStanding> standings;
  final String userMemberId;
  final LeagueModel league;
  final String leagueId;

  bool _isUserTeam(TeamStanding s) => league.teams.any(
    (t) => t.id == s.team.id && t.memberIds.contains(userMemberId),
  );

  List<TeamStanding> _previewRows() {
    if (standings.length <= 3) return standings;

    final userIndex = standings.indexWhere(_isUserTeam);
    if (userIndex <= 0) return standings.sublist(0, 3);
    if (userIndex >= standings.length - 1) {
      return standings.sublist(standings.length - 3);
    }
    return standings.sublist(userIndex - 1, userIndex + 2);
  }

  @override
  Widget build(BuildContext context) {
    final preview = _previewRows();

    return PreviewTable(
      columns: const [
        PreviewColumn(
          label: '#',
          width: 32,
          style: PreviewCellStyle.rank,
        ),
        PreviewColumn(
          label: 'Team',
          flex: 1,
          style: PreviewCellStyle.name,
        ),
        PreviewColumn(
          label: 'W-L-T',
          width: 56,
          alignment: TextAlign.center,
          style: PreviewCellStyle.secondary,
        ),
        PreviewColumn(
          label: 'Pts',
          width: 40,
          alignment: TextAlign.end,
          style: PreviewCellStyle.value,
        ),
      ],
      rows: preview
          .map(
            (s) => PreviewRow(
              cells: [
                '#${s.rank}',
                s.team.name,
                '${s.wins}-${s.losses}-${s.ties}',
                _fmtPts(s.totalPoints),
              ],
              isHighlighted: _isUserTeam(s),
              onTap: () => context.go('/league/$leagueId/standings'),
            ),
          )
          .toList(),
      viewAllLabel: 'Full Standings',
      onViewAll: () => context.go('/league/$leagueId/standings'),
    );
  }

  String _fmtPts(double pts) {
    if (pts == pts.truncateToDouble()) return pts.toInt().toString();
    return pts.toStringAsFixed(1);
  }
}
