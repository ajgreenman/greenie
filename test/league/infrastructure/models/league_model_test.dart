import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';

void main() {
  group('LeagueModel', () {
    test('stores all fields', () {
      final course = CourseModel(id: 'c1', name: 'Test', holes: []);
      final league = LeagueModel(
        id: 'l1',
        name: 'Test League',
        course: course,
        day: DayOfTheWeek.monday,
        memberIds: ['m1', 'm2'],
        adminId: 'u1',
      );
      expect(league.id, 'l1');
      expect(league.name, 'Test League');
      expect(league.course, course);
      expect(league.day, DayOfTheWeek.monday);
      expect(league.memberIds, ['m1', 'm2']);
      expect(league.adminId, 'u1');
    });
  });
}
