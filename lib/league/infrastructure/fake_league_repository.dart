import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/league/infrastructure/league_repository.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

class FakeLeagueRepository extends LeagueRepository {
  @override
  Future<List<LeagueModel>> fetchLeagues() async {
    return _leagues;
  }

  final _leagues = [
    LeagueModel(
      name: 'Wednesday Amateur Players (WAP)',
      course: FakeCourseRepository.courses.first,
      day: DayOfTheWeek.wednesday,
    ),
  ];
}
