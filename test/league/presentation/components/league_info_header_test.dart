import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/presentation/components/league_info_header.dart';

final _testLeague = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: CourseModel(
    id: 'course-1',
    name: 'Test Course',
    holes: [HoleModel(number: 1, par: 4)],
  ),
  day: DayOfTheWeek.wednesday,
  memberIds: const ['member-1'],
  adminId: 'member-1',
);

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('LeagueInfoHeader', () {
    testWidgets('displays league name, course, and day', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(LeagueInfoHeader(league: _testLeague)),
      );
      expect(find.text('Test League'), findsOneWidget);
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Wednesdays'), findsOneWidget);
    });
  });
}
