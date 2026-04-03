import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/presentation/stats_screen.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_model.dart';
import 'package:greenie/user/user_providers.dart';

const _testUser = UserModel(
  id: 'user-1',
  name: 'Alice',
  email: 'alice@test.com',
  isAdmin: false,
  memberId: 'member-1',
);

const _testMembers = [MemberModel(id: 'member-1', name: 'Alice', handicap: 10)];

// 2 completed rounds, member-1 scores: 40 and 36 → avg 38, best 36
final _testRounds = [
  RoundModel(
    id: 'round-1',
    leagueId: 'league-1',
    courseId: 'course-1',
    date: DateTime(2025, 6, 4),
    status: RoundStatus.completed,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    scores: const [
      ScoreModel(
        memberId: 'member-1',
        holeScores: {1: 5, 2: 4, 3: 5, 4: 4, 5: 4, 6: 5, 7: 4, 8: 5, 9: 4},
      ),
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
      ScoreModel(
        memberId: 'member-1',
        holeScores: {1: 4, 2: 4, 3: 4, 4: 4, 5: 4, 6: 4, 7: 4, 8: 4, 9: 4},
      ),
    ],
    matchups: const [],
  ),
];

Widget _buildScreen({List<RoundModel>? rounds, bool throwError = false}) {
  return ProviderScope(
    overrides: [
      currentUserProvider.overrideWith((ref) async => _testUser),
      fetchMembersProvider(
        'league-1',
      ).overrideWith((ref) async => _testMembers),
      fetchRoundsForLeagueProvider('league-1').overrideWith((ref) async {
        if (throwError) throw Exception('network error');
        return rounds ?? _testRounds;
      }),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const StatsScreen(leagueId: 'league-1'),
    ),
  );
}

void main() {
  group('StatsScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows Stats in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.widgetWithText(AppBar, 'Stats'), findsOneWidget);
    });

    testWidgets('shows rounds played count after load', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Rounds Played'), findsOneWidget);
    });

    testWidgets('shows average score', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // round-1: 40 strokes, round-2: 36 strokes → avg 38
      expect(find.text('38'), findsOneWidget);
      expect(find.text('Avg Score'), findsOneWidget);
    });

    testWidgets('shows best round', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // '36' appears in both the stat card and the recent rounds score
      expect(find.text('36'), findsWidgets);
      expect(find.text('Best Round'), findsOneWidget);
    });

    testWidgets('shows handicap', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Handicap'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });

    testWidgets('shows Recent Rounds section header', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Recent Rounds'), findsOneWidget);
    });

    testWidgets('shows round dates in recent rounds', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // Most recent round first (sorted by date desc)
      expect(find.text('Jun 11, 2025'), findsOneWidget);
    });

    testWidgets('shows empty state for rounds when no completed rounds', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(rounds: []));
      await tester.pumpAndSettle();
      expect(find.text('0'), findsOneWidget);
      expect(find.text('No completed rounds yet'), findsOneWidget);
    });

    testWidgets('toggle switches to League view', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      // Tap the SegmentedButton 'League' option (first occurrence; nav bar also has 'League')
      await tester.tap(find.text('League').first);
      await tester.pump();
      expect(find.text('League stats coming soon'), findsOneWidget);
    });

    testWidgets('toggle switches back to Personal view', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      await tester.tap(find.text('League').first);
      await tester.pump();
      await tester.tap(find.text('Personal'));
      await tester.pump();
      expect(find.text('Rounds Played'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpWidget(_buildScreen(throwError: true));
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });
  });
}
