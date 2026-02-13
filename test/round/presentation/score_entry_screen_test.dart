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
import 'package:greenie/round/presentation/score_entry_screen.dart';
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

final _testRound = RoundModel(
  id: 'round-1',
  leagueId: 'league-1',
  courseId: 'course-1',
  date: DateTime(2025, 6, 25),
  status: RoundStatus.inProgress,
  holeNumbers: const [1, 2, 3],
  scores: const [
    ScoreModel(memberId: 'member-1', holeScores: {1: 4, 2: 3}),
    ScoreModel(memberId: 'member-2', holeScores: {1: 5}),
  ],
);

void main() {
  group('ScoreEntryScreen', () {
    testWidgets('shows Score Entry title', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const ScoreEntryScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Score Entry'), findsOneWidget);
    });

    testWidgets('shows save button', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const ScoreEntryScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.save), findsOneWidget);
    });

    testWidgets('shows player names in scorecard', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const ScoreEntryScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob Jones'), findsOneWidget);
    });

    testWidgets('opens bottom sheet when tapping a score cell', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchRoundProvider(
              'round-1',
            ).overrideWith((ref) async => _testRound),
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const ScoreEntryScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Tap on a dash (empty score cell) to open the bottom sheet
      await tester.tap(find.text('-').first);
      await tester.pumpAndSettle();
      // Bottom sheet should show ChoiceChips 1-10
      expect(find.text('1'), findsWidgets);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: buildLightTheme(),
            home: const ScoreEntryScreen(
              leagueId: 'league-1',
              roundId: 'round-1',
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
