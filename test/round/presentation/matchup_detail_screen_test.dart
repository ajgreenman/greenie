// ignore_for_file: scoped_providers_should_specify_dependencies
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/presentation/matchup_detail_screen.dart';
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

const _a1 = MemberModel(id: 'a1', name: 'Alice One', handicap: 5);
const _b1 = MemberModel(id: 'b1', name: 'Bob One', handicap: 12);
const _a2 = MemberModel(id: 'a2', name: 'Carol Two', handicap: 6);
const _b2 = MemberModel(id: 'b2', name: 'Dave Two', handicap: 14);

MatchupResult _makeResult({int holeCount = 9}) {
  final holes = List.generate(
    holeCount,
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

  return MatchupResult(
    matchup: _matchup,
    team1: _team1,
    team2: _team2,
    team1AMember: _a1,
    team2AMember: _a2,
    team1BMember: _b1,
    team2BMember: _b2,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    holeResults: holes,
    bonusAPoints: const PointResult(team1Points: 2, team2Points: 0),
    bonusBPoints: const PointResult(team1Points: 2, team2Points: 0),
    bonusTeamPoints: const PointResult(team1Points: 1, team2Points: 0),
  );
}

Widget _buildScreen({MatchupResult? result, bool throwError = false}) {
  return ProviderScope(
    overrides: [
      fetchMatchupResultProvider('round-1', 'matchup-1').overrideWith((
        ref,
      ) async {
        if (throwError) throw Exception('network error');
        return result ?? _makeResult();
      }),
    ],
    child: MaterialApp(
      theme: GreenieTheme.light,
      home: const MatchupDetailScreen(
        leagueId: 'league-1',
        roundId: 'round-1',
        matchupId: 'matchup-1',
      ),
    ),
  );
}

void main() {
  group('MatchupDetailScreen', () {
    testWidgets('shows loading indicator initially', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows Matchup in app bar', (tester) async {
      await tester.pumpWidget(_buildScreen());
      expect(find.text('Matchup'), findsOneWidget);
    });

    testWidgets('shows team names after data loads', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Alpha Squad'), findsWidgets);
      expect(find.text('Beta Squad'), findsWidgets);
    });

    testWidgets('shows per-hole table', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Hole-by-Hole'), findsOneWidget);
      expect(find.text('Hole'), findsOneWidget);
    });

    testWidgets('shows bonus section', (tester) async {
      await tester.pumpWidget(_buildScreen());
      await tester.pumpAndSettle();
      expect(find.text('Round Bonus'), findsOneWidget);
    });

    testWidgets('shows error state', (tester) async {
      await tester.pumpWidget(_buildScreen(throwError: true));
      await tester.pumpAndSettle();
      expect(find.textContaining('Error'), findsOneWidget);
    });

    testWidgets('shows outcome chip when complete', (tester) async {
      await tester.pumpWidget(_buildScreen(result: _makeResult(holeCount: 9)));
      await tester.pumpAndSettle();
      expect(find.text('Win'), findsOneWidget);
    });

    testWidgets('shows partial hole table for in-progress round', (
      tester,
    ) async {
      await tester.pumpWidget(_buildScreen(result: _makeResult(holeCount: 4)));
      await tester.pumpAndSettle();
      // Only 4 hole rows + 5 dash rows (for holes 5-9 not played)
      expect(find.text('—'), findsWidgets);
    });
  });
}
