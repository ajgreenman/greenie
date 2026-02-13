import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/presentation/round_list_screen.dart';
import 'package:greenie/round/round_providers.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Test Course',
  holes: [
    HoleModel(number: 1, par: 4),
    HoleModel(number: 2, par: 3),
    HoleModel(number: 3, par: 5),
  ],
);

final _testCompletedRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 4),
  status: RoundStatus.completed,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(memberId: 'member-1', holeScores: {1: 4, 2: 3, 3: 5}),
  ],
);

final _testUpcomingRound = RoundModel(
  id: 'round-2',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 7, 2),
  status: RoundStatus.upcoming,
  holeNumbers: const [1, 2, 3],
  scores: const [],
);

void main() {
  group('RoundListScreen', () {
    testWidgets('shows round list when data loads', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundsForLeagueProvider('league-1').overrideWith(
              (ref) async => [_testCompletedRound, _testUpcomingRound],
            ),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundListScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Course'), findsNWidgets(2));
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
    });

    testWidgets('shows empty state for no rounds', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => []),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundListScreen(leagueId: 'league-1'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No rounds yet.'), findsOneWidget);
    });

    testWidgets('shows Rounds title in app bar', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundsForLeagueProvider(
              'league-1',
            ).overrideWith((ref) async => []),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundListScreen(leagueId: 'league-1'),
          ),
        ),
      );
      expect(find.text('Rounds'), findsOneWidget);
    });
  });
}
