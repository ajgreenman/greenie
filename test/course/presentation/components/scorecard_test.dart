import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';
import 'package:greenie/course/presentation/components/scorecard.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

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

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('Scorecard', () {
    testWidgets('renders hole headers', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
          ),
        ),
      );
      expect(find.text('Hole'), findsOneWidget);
      expect(find.text('1'), findsWidgets);
      expect(find.text('2'), findsWidgets);
      expect(find.text('3'), findsWidgets);
    });

    testWidgets('renders par row', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
          ),
        ),
      );
      expect(find.text('Par'), findsOneWidget);
    });

    testWidgets('renders player names', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
          ),
        ),
      );
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob Jones'), findsOneWidget);
    });

    testWidgets('renders skins row', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
          ),
        ),
      );
      expect(find.text('Skins'), findsOneWidget);
    });

    testWidgets('renders totals', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
          ),
        ),
      );
      expect(find.text('Tot'), findsOneWidget);
      // Alice: 4+3+5=12
      expect(find.text('12'), findsWidgets);
    });

    testWidgets('calls onScoreTap when editable and tapped', (tester) async {
      String? tappedMember;
      int? tappedHole;
      await tester.pumpWidget(
        _buildTestApp(
          Scorecard(
            round: _testCompletedRound,
            course: _testCourse,
            members: _testMembers,
            isEditable: true,
            onScoreTap: (memberId, holeNumber) {
              tappedMember = memberId;
              tappedHole = holeNumber;
            },
          ),
        ),
      );
      // Tap member-2's score on hole 1 (score=5, par=4 → bogey)
      // Using '6' (member-2, hole 3) since it's unique in the scorecard
      await tester.tap(find.text('6').first);
      expect(tappedMember, 'member-2');
      expect(tappedHole, 3);
    });
  });
}
