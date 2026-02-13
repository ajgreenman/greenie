import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/presentation/components/round_leaderboard.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_providers.dart';

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

void main() {
  group('RoundLeaderboard', () {
    testWidgets('shows ranked players by total strokes', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMembersProvider(
              'league-1',
            ).overrideWith((ref) async => _testMembers),
          ],
          child: MaterialApp(
            theme: buildLightTheme(),
            home: Scaffold(
              body: RoundLeaderboard(
                round: _testCompletedRound,
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Leaderboard'), findsOneWidget);
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('Bob Jones'), findsOneWidget);
      // Alice: 4+3+5=12, Bob: 5+4+6=15
      expect(find.text('12'), findsOneWidget);
      expect(find.text('15'), findsOneWidget);
    });
  });
}
