import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/dev/dev_scenario.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/models.dart';

class FakeLeagueRepository extends LeagueRepository {
  FakeLeagueRepository({this.scenario = const ActiveSeason()});

  final DevScenario scenario;

  @override
  Future<List<LeagueModel>> fetchLeagues() async => switch (scenario) {
    FreshSignup() => [],
    MultiLeague() => [_fullLeague, _secondLeague],
    NewLeagueAdmin() => [_emptyLeagueAdmin],
    NewLeagueMember() || FirstRoundUpcoming() => [_smallLeague],
    _ => [_fullLeague],
  };

  @override
  Future<LeagueModel> fetchLeague(String id) async {
    final all = await fetchLeagues();
    return all.firstWhere((l) => l.id == id);
  }

  // ── League definitions ───────────────────────────────────────────────────

  /// Admin-only league, no teams, no rounds yet.
  static final _emptyLeagueAdmin = LeagueModel(
    id: 'league-1',
    name: 'Wednesday Amateur Players',
    course: FakeCourseRepository.courses.first,
    day: DayOfTheWeek.wednesday,
    memberIds: const ['user-1'],
    adminId: 'user-1',
    teams: const [],
  );

  /// Small group, no teams formed yet.
  static final _smallLeague = LeagueModel(
    id: 'league-1',
    name: 'Wednesday Amateur Players',
    course: FakeCourseRepository.courses.first,
    day: DayOfTheWeek.wednesday,
    memberIds: const ['user-1', 'user-2', 'user-4', 'user-6'],
    adminId: 'user-1',
    teams: const [],
  );

  /// Full league with all 14 members and 7 teams.
  static final _fullLeague = LeagueModel(
    id: 'league-1',
    name: 'Wednesday Amateur Players',
    course: FakeCourseRepository.courses.first,
    day: DayOfTheWeek.wednesday,
    memberIds: const [
      'user-1', 'user-2', 'user-3', 'user-4', 'user-5', 'user-6',
      'user-7', 'user-8', 'user-9', 'user-10', 'user-11', 'user-12',
      'user-13', 'user-14',
    ],
    adminId: 'user-1',
    teams: const [
      // team-1: Ben (hdcp 1) + Joel (hdcp 17)
      TeamModel(id: 'team-1', leagueId: 'league-1', memberIds: ['user-14', 'user-13'], name: 'Casciano / Bremer'),
      // team-2: Brady (hdcp 2) + Matt (hdcp 12)
      TeamModel(id: 'team-2', leagueId: 'league-1', memberIds: ['user-6', 'user-10'],  name: 'Greenman / Ayers'),
      // team-3: Aaron (hdcp 3) + Brett (hdcp 15)
      TeamModel(id: 'team-3', leagueId: 'league-1', memberIds: ['user-4', 'user-8'],   name: 'Greenman / Knaus'),
      // team-4: Ryan C (hdcp 5) + Ryan A (hdcp 12)
      TeamModel(id: 'team-4', leagueId: 'league-1', memberIds: ['user-7', 'user-9'],   name: 'Confer / Ayers'),
      // team-5: Andrew (hdcp 6) + Mike (hdcp 8)
      TeamModel(id: 'team-5', leagueId: 'league-1', memberIds: ['user-11', 'user-3'],  name: 'Dunscombe / Mike'),
      // team-6: Brandon (hdcp 9) + Jake (hdcp 11)
      TeamModel(id: 'team-6', leagueId: 'league-1', memberIds: ['user-2', 'user-12'],  name: 'Ayers / Steggles'),
      // team-7: AJ (hdcp 10) + Adam (hdcp 10)
      TeamModel(id: 'team-7', leagueId: 'league-1', memberIds: ['user-1', 'user-5'],   name: 'Greenman / Boelkins'),
    ],
  );

  /// Second league for the MultiLeague scenario.
  static final _secondLeague = LeagueModel(
    id: 'league-2',
    name: 'Faith Reformed',
    course: FakeCourseRepository.courses[1],
    day: DayOfTheWeek.thursday,
    memberIds: const ['user-1', 'user-2', 'user-3'],
    adminId: 'user-1',
    teams: const [],
  );
}
