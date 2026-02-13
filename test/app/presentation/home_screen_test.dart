import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/app/presentation/home_screen.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/infrastructure/models/league_model.dart';
import 'package:greenie/league/league_providers.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Test Course',
  holes: [HoleModel(number: 1, par: 4)],
);

final _testLeague = LeagueModel(
  id: 'league-1',
  name: 'Test League',
  course: _testCourse,
  day: DayOfTheWeek.wednesday,
  memberIds: const ['member-1'],
  adminId: 'member-1',
);

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('HomeScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(_buildTestApp(const HomeScreen()));
      expect(find.textContaining('Greenie'), findsOneWidget);
    });

    testWidgets('shows league list when data loads', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeaguesProvider.overrideWith((ref) async => [_testLeague]),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test League'), findsOneWidget);
      expect(find.textContaining('Test Course'), findsOneWidget);
    });

    testWidgets('shows empty state for no leagues', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [fetchLeaguesProvider.overrideWith((ref) async => [])],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No leagues yet.'), findsOneWidget);
    });

    testWidgets('shows error message on failure', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchLeaguesProvider.overrideWith((ref) => throw Exception('fail')),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const HomeScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
