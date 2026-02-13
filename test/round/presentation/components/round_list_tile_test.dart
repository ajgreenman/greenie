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
import 'package:greenie/round/presentation/components/round_list_tile.dart';

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

final _testInProgressRound = RoundModel(
  id: 'round-3',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 25),
  status: RoundStatus.inProgress,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(memberId: 'member-1', holeScores: {1: 4}),
  ],
);

void main() {
  group('RoundListTile', () {
    testWidgets('displays course name, date, and status', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: RoundListTile(
                round: _testCompletedRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
    });

    testWidgets('shows Upcoming status for upcoming round', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: RoundListTile(
                round: _testUpcomingRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Upcoming'), findsOneWidget);
    });

    testWidgets('shows In Progress status', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: RoundListTile(
                round: _testInProgressRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('In Progress'), findsOneWidget);
    });
  });
}
