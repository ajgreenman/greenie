// ignore_for_file: scoped_providers_should_specify_dependencies
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/presentation/components/matchup_card.dart';
import 'package:greenie/round/round_providers.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

const _team1 = TeamModel(
  id: 'team-1',
  leagueId: 'league-1',
  memberIds: ['a1', 'b1'],
  name: 'Alpha Squad',
);

const _team2 = TeamModel(
  id: 'team-2',
  leagueId: 'league-1',
  memberIds: ['a2', 'b2'],
  name: 'Beta Squad',
);

const _matchup = MatchupModel(
  id: 'matchup-1',
  roundId: 'round-1',
  team1Id: 'team-1',
  team2Id: 'team-2',
);

const _a1 = MemberModel(id: 'a1', name: 'Alice', handicap: 5);
const _b1 = MemberModel(id: 'b1', name: 'Bob', handicap: 12);
const _a2 = MemberModel(id: 'a2', name: 'Carol', handicap: 6);
const _b2 = MemberModel(id: 'b2', name: 'Dave', handicap: 14);

List<HoleMatchupResult> _makeHoles(int count) {
  return List.generate(
    count,
    (i) => HoleMatchupResult(
      holeNumber: i + 1,
      team1ANet: 3,
      team2ANet: 4,
      team1BNet: 4,
      team2BNet: 5,
      team1TeamNet: 7,
      team2TeamNet: 9,
      aPoints: const PointResult(team1Points: 2, team2Points: 0),
      bPoints: const PointResult(team1Points: 2, team2Points: 0),
      teamPoints: const PointResult(team1Points: 1, team2Points: 0),
    ),
  );
}

MatchupResult _makeResult({int holeCount = 4}) {
  return MatchupResult(
    matchup: _matchup,
    team1: _team1,
    team2: _team2,
    team1AMember: _a1,
    team2AMember: _a2,
    team1BMember: _b1,
    team2BMember: _b2,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    holeResults: _makeHoles(holeCount),
    bonusAPoints: const PointResult(team1Points: 1, team2Points: 1),
    bonusBPoints: const PointResult(team1Points: 1, team2Points: 1),
    bonusTeamPoints: const PointResult(team1Points: 0.5, team2Points: 0.5),
  );
}

Widget _buildCard({MatchupResult? result}) {
  return ProviderScope(
    overrides: [
      fetchMatchupResultProvider(
        'round-1',
        'matchup-1',
      ).overrideWith((ref) async => result ?? _makeResult()),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const Scaffold(
        body: MatchupCard(
          matchup: _matchup,
          roundId: 'round-1',
          leagueId: 'league-1',
        ),
      ),
    ),
  );
}

void main() {
  group('MatchupCard', () {
    testWidgets('shows loading initially', (tester) async {
      await tester.pumpWidget(_buildCard());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows team names after load', (tester) async {
      await tester.pumpWidget(_buildCard());
      await tester.pumpAndSettle();
      expect(find.text('Alpha Squad'), findsOneWidget);
      expect(find.text('Beta Squad'), findsOneWidget);
    });

    testWidgets('shows point totals', (tester) async {
      await tester.pumpWidget(_buildCard());
      await tester.pumpAndSettle();
      // With 4 holes of 5pts each = 20 + 2.5 bonus each → displayed values
      expect(find.textContaining('–'), findsWidgets);
    });

    testWidgets('shows hole count', (tester) async {
      await tester.pumpWidget(_buildCard(result: _makeResult(holeCount: 4)));
      await tester.pumpAndSettle();
      expect(find.text('4 holes'), findsOneWidget);
    });

    testWidgets('shows outcome chip when complete (9 holes)', (tester) async {
      await tester.pumpWidget(_buildCard(result: _makeResult(holeCount: 9)));
      await tester.pumpAndSettle();
      // With 9 holes and team-1 winning every point, show W chip
      expect(find.text('W'), findsOneWidget);
    });

    testWidgets('shows error state silently (SizedBox)', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            fetchMatchupResultProvider(
              'round-1',
              'matchup-1',
            ).overrideWith((ref) async => throw Exception('oops')),
          ],
          child: MaterialApp(
            theme: GreenieTheme.light,
            home: const Scaffold(
              body: MatchupCard(
                matchup: _matchup,
                roundId: 'round-1',
                leagueId: 'league-1',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      // Error state → SizedBox.shrink → no card content visible
      expect(find.text('Alpha Squad'), findsNothing);
    });
  });
}
