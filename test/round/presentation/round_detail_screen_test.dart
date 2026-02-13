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
import 'package:greenie/round/presentation/round_detail_screen.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_providers.dart';

final _testCourse = CourseModel(
  id: 'course-1',
  name: 'Test Course',
  holes: [
    HoleModel(number: 1, par: 4),
    HoleModel(number: 2, par: 3),
    HoleModel(number: 3, par: 5),
  ],
);

const _testMembers = [
  MemberModel(id: 'member-1', name: 'Alice Smith', handicap: 10),
  MemberModel(id: 'member-2', name: 'Bob Jones', handicap: 18),
];

final _testCompletedRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 4),
  status: RoundStatus.completed,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(memberId: 'member-1', holeScores: {1: 4, 2: 3, 3: 5}),
    ScoreModel(memberId: 'member-2', holeScores: {1: 5, 2: 4, 3: 6}),
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
  group('RoundDetailScreen', () {
    testWidgets('shows round info for completed round', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testCompletedRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Course'), findsWidgets);
      expect(find.text('Leaderboard'), findsOneWidget);
    });

    testWidgets('shows Start Round button for upcoming round', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-2',
            ).overrideWith((ref) async => _testUpcomingRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-2',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Start Round'), findsOneWidget);
    });

    testWidgets('shows Continue Round button for in-progress round', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-3',
            ).overrideWith((ref) async => _testInProgressRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-3',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Continue Round'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const RoundDetailScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      expect(find.text('Round'), findsOneWidget);
    });
  });
}
