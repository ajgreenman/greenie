import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';

void main() {
  group('DayOfTheWeek', () {
    test('displayName capitalizes first letter', () {
      expect(DayOfTheWeek.monday.displayName, 'Monday');
      expect(DayOfTheWeek.tuesday.displayName, 'Tuesday');
      expect(DayOfTheWeek.wednesday.displayName, 'Wednesday');
      expect(DayOfTheWeek.thursday.displayName, 'Thursday');
      expect(DayOfTheWeek.friday.displayName, 'Friday');
      expect(DayOfTheWeek.saturday.displayName, 'Saturday');
      expect(DayOfTheWeek.sunday.displayName, 'Sunday');
    });
  });
}
