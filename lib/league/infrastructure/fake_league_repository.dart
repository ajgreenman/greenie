import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

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
        'member-1',
        'member-2',
        'member-3',
        'member-4',
        'member-5',
        'member-6',
      ],
      adminId: 'user-1',
    ),
    LeagueModel(
      id: 'league-2',
      name: 'Faith Reformed',
      course: FakeCourseRepository.courses[1],
      day: DayOfTheWeek.thursday,
      memberIds: ['member-1', 'member-2', 'member-3'],
      adminId: 'user-1',
    ),
  ];
}
