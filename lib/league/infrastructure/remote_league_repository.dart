import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/models/models.dart';
import 'package:greenie/data/supabase/supabase_service.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/models.dart';

class RemoteLeagueRepository extends LeagueRepository {
  RemoteLeagueRepository(this._service);

  final SupabaseService _service;

  @override
  Future<List<LeagueModel>> fetchLeagues() async {
    final rows = await _service.fetchLeagues();
    return rows.map(_mapLeague).toList();
  }

  @override
  Future<LeagueModel> fetchLeague(String id) async {
    final row = await _service.fetchLeague(id);
    return _mapLeague(row);
  }

  LeagueModel _mapLeague(Map<String, dynamic> row) {
    final courseRow = row['courses'] as Map<String, dynamic>;
    final holeRows = courseRow['holes'] as List<dynamic>;
    final holes = holeRows
        .map((h) => HoleModel(
              number: h['number'] as int,
              par: h['par'] as int,
            ))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    final course = CourseModel(
      id: courseRow['id'] as String,
      name: courseRow['name'] as String,
      holes: holes,
    );

    final memberIds = (row['league_members'] as List<dynamic>)
        .map((m) => m['user_id'] as String)
        .toList();

    final teams = (row['teams'] as List<dynamic>).map((t) {
      final teamMemberIds = (t['team_members'] as List<dynamic>)
          .map((m) => m['user_id'] as String)
          .toList();
      return TeamModel(
        id: t['id'] as String,
        leagueId: row['id'] as String,
        name: t['name'] as String,
        memberIds: teamMemberIds,
      );
    }).toList();

    return LeagueModel(
      id: row['id'] as String,
      name: row['name'] as String,
      course: course,
      day: DayOfTheWeek.values.byName(row['day'] as String),
      memberIds: memberIds,
      adminId: row['admin_user_id'] as String,
      teams: teams,
    );
  }
}
