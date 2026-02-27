import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/presentation/components/rounds_preview.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';

final _rounds = [
  RoundModel(
    id: 'round-1',
    leagueId: 'league-1',
    courseId: 'course-1',
    date: DateTime(2025, 6, 4),
    status: RoundStatus.completed,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    scores: const [
      ScoreModel(memberId: 'member-1', holeScores: {1: 5, 2: 4, 3: 5, 4: 4, 5: 4, 6: 5, 7: 4, 8: 5, 9: 4}),
    ],
    matchups: const [],
  ),
  RoundModel(
    id: 'round-2',
    leagueId: 'league-1',
    courseId: 'course-1',
    date: DateTime(2025, 6, 11),
    status: RoundStatus.completed,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    scores: const [
      ScoreModel(memberId: 'member-1', holeScores: {1: 4, 2: 4, 3: 4, 4: 4, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4}),
    ],
    matchups: const [],
  ),
  RoundModel(
    id: 'round-3',
    leagueId: 'league-1',
    courseId: 'course-1',
    date: DateTime(2025, 6, 18),
    status: RoundStatus.completed,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    scores: const [
      ScoreModel(memberId: 'member-1', holeScores: {1: 3, 2: 4, 3: 4, 4: 4, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4}),
    ],
    matchups: const [],
  ),
  RoundModel(
    id: 'round-4',
    leagueId: 'league-1',
    courseId: 'course-1',
    date: DateTime(2025, 6, 25),
    status: RoundStatus.completed,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    scores: const [
      ScoreModel(memberId: 'member-1', holeScores: {1: 4, 2: 4, 3: 4, 4: 4, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4}),
    ],
    matchups: const [],
  ),
];

Widget _buildWidget({required List<RoundModel> rounds}) {
  return MaterialApp(
    theme: GreenieTheme.light,
    home: Scaffold(
      body: RoundsPreview(
        rounds: rounds,
        memberId: 'member-1',
        leagueId: 'league-1',
      ),
    ),
  );
}

void main() {
  group('RoundsPreview', () {
    testWidgets('shows column headers', (tester) async {
      await tester.pumpWidget(_buildWidget(rounds: _rounds));
      expect(find.text('Date'), findsOneWidget);
      expect(find.text('Score'), findsOneWidget);
    });

    testWidgets('shows All Rounds link', (tester) async {
      await tester.pumpWidget(_buildWidget(rounds: _rounds));
      expect(find.text('All Rounds'), findsOneWidget);
    });

    testWidgets('shows most recent round first', (tester) async {
      await tester.pumpWidget(_buildWidget(rounds: _rounds));
      expect(find.text('Jun 25, 2025'), findsOneWidget);
    });

    testWidgets('shows at most 3 rounds', (tester) async {
      await tester.pumpWidget(_buildWidget(rounds: _rounds));
      // 4 rounds available — only 3 shown. Jun 4 is oldest, should not appear.
      expect(find.text('Jun 4, 2025'), findsNothing);
      expect(find.text('Jun 11, 2025'), findsOneWidget);
      expect(find.text('Jun 18, 2025'), findsOneWidget);
      expect(find.text('Jun 25, 2025'), findsOneWidget);
    });

    testWidgets('shows user score for each round', (tester) async {
      await tester.pumpWidget(_buildWidget(rounds: _rounds));
      // round-4: 36, round-3: 35, round-2: 36 → two 36s and one 35
      expect(find.text('35'), findsOneWidget);
    });

    testWidgets('excludes rounds without member score', (tester) async {
      final noScoreRound = RoundModel(
        id: 'round-x',
        leagueId: 'league-1',
        courseId: 'course-1',
        date: DateTime(2025, 7, 1),
        status: RoundStatus.completed,
        holeNumbers: const [1, 2, 3],
        scores: const [
          ScoreModel(memberId: 'member-99', holeScores: {1: 4, 2: 4, 3: 4}),
        ],
        matchups: const [],
      );
      await tester.pumpWidget(_buildWidget(rounds: [..._rounds, noScoreRound]));
      // round-x has no score for member-1, should be excluded
      expect(find.text('Jul 1, 2025'), findsNothing);
    });

    testWidgets('excludes non-completed rounds', (tester) async {
      final upcomingRound = RoundModel(
        id: 'round-upcoming',
        leagueId: 'league-1',
        courseId: 'course-1',
        date: DateTime(2025, 7, 2),
        status: RoundStatus.upcoming,
        holeNumbers: const [1, 2, 3],
        scores: const [],
        matchups: const [],
      );
      await tester.pumpWidget(
        _buildWidget(rounds: [..._rounds, upcomingRound]),
      );
      expect(find.text('Jul 2, 2025'), findsNothing);
    });
  });
}
