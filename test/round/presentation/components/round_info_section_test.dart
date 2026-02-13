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
import 'package:greenie/round/presentation/components/round_info_section.dart';

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
    ScoreModel(memberId: 'member-2', holeScores: {1: 5, 2: 4, 3: 6}),
  ],
);

void main() {
  group('RoundInfoSection', () {
    testWidgets('displays course name, date, and holes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchCourseProvider(
              'course-1',
            ).overrideWith((ref) async => _testCourse),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(body: RoundInfoSection(round: _testCompletedRound)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Test Course'), findsOneWidget);
      expect(find.text('Jun 4, 2025'), findsOneWidget);
      expect(find.text('Holes 1-3'), findsOneWidget);
    });
  });
}
