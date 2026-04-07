import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/models.dart';

class FakeLeagueRepository extends LeagueRepository {
  @override
  Future<List<LeagueModel>> fetchLeagues() async {
    return leagues;
  }

  @override
  Future<LeagueModel> fetchLeague(String id) async {
    return leagues.where((l) => l.id == id).first;
  }

  static final leagues = [
    LeagueModel(
      id: 'league-1',
      name: 'Wednesday Amateur Players',
      course: FakeCourseRepository.courses.first,
      day: DayOfTheWeek.wednesday,
      memberIds: [
        'user-1',
        'user-2',
        'user-3',
        'user-4',
        'user-5',
        'user-6',
        'user-7',
        'user-8',
        'user-9',
        'user-10',
        'user-11',
        'user-12',
        'user-13',
        'user-14',
      ],
      adminId: 'user-1',
      teams: [
        // team-1: Ben (hdcp 1) + Joel (hdcp 17)
        const TeamModel(
          id: 'team-1',
          leagueId: 'league-1',
          memberIds: ['user-14', 'user-13'],
          name: 'Casciano / Bremer',
        ),
        // team-2: Brady (hdcp 2) + Matt (hdcp 12)
        const TeamModel(
          id: 'team-2',
          leagueId: 'league-1',
          memberIds: ['user-6', 'user-10'],
          name: 'Greenman / Ayers',
        ),
        // team-3: Aaron (hdcp 3) + Brett (hdcp 15)
        const TeamModel(
          id: 'team-3',
          leagueId: 'league-1',
          memberIds: ['user-4', 'user-8'],
          name: 'Greenman / Knaus',
        ),
        // team-4: Ryan C (hdcp 5) + Ryan A (hdcp 12)
        const TeamModel(
          id: 'team-4',
          leagueId: 'league-1',
          memberIds: ['user-7', 'user-9'],
          name: 'Confer / Ayers',
        ),
        // team-5: Andrew (hdcp 6) + Mike (hdcp 8)
        const TeamModel(
          id: 'team-5',
          leagueId: 'league-1',
          memberIds: ['user-11', 'user-3'],
          name: 'Dunscombe / Mike',
        ),
        // team-6: Brandon (hdcp 9) + Jake (hdcp 11)
        const TeamModel(
          id: 'team-6',
          leagueId: 'league-1',
          memberIds: ['user-2', 'user-12'],
          name: 'Ayers / Steggles',
        ),
        // team-7: AJ (hdcp 10) + Adam (hdcp 10) — tied handicap edge case
        const TeamModel(
          id: 'team-7',
          leagueId: 'league-1',
          memberIds: ['user-1', 'user-5'],
          name: 'Greenman / Boelkins',
        ),
      ],
    ),
    LeagueModel(
      id: 'league-2',
      name: 'Faith Reformed',
      course: FakeCourseRepository.courses[1],
      day: DayOfTheWeek.thursday,
      memberIds: ['user-1', 'user-2', 'user-3'],
      adminId: 'user-1',
      teams: const [],
    ),
  ];
}
