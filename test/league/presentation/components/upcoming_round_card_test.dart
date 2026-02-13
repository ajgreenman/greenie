import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/course_providers.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/league/presentation/components/upcoming_round_card.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Pine Valley',
  holes: [HoleModel(number: 1, par: 4)],
);

final _testUpcomingRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 7, 6),
  status: RoundStatus.upcoming,
  holeNumbers: const [1],
  scores: const [],
);

final _testInProgressRound = RoundModel(
  id: 'round-2',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 29),
  status: RoundStatus.inProgress,
  holeNumbers: const [1],
  scores: const [],
);

void main() {
  group('UpcomingRoundCard', () {
    testWidgets('shows Next Round for upcoming round', (tester) async {
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
              body: UpcomingRoundCard(
                round: _testUpcomingRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Next Round'), findsOneWidget);
      expect(find.text('Round In Progress'), findsNothing);
    });

    testWidgets('shows Round In Progress for in-progress round', (
      tester,
    ) async {
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
              body: UpcomingRoundCard(
                round: _testInProgressRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Round In Progress'), findsOneWidget);
      expect(find.text('Next Round'), findsNothing);
    });

    testWidgets('shows course name', (tester) async {
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
              body: UpcomingRoundCard(
                round: _testUpcomingRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.textContaining('Pine Valley'), findsOneWidget);
    });

    testWidgets('shows chevron icon', (tester) async {
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
              body: UpcomingRoundCard(
                round: _testUpcomingRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });
}
