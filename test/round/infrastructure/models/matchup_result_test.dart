import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

const _team1 = TeamModel(
  id: 'team-1',
  leagueId: 'league-1',
  memberIds: ['a1', 'b1'],
  name: 'Team 1',
);

const _team2 = TeamModel(
  id: 'team-2',
  leagueId: 'league-1',
  memberIds: ['a2', 'b2'],
  name: 'Team 2',
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

MatchupResult _makeResult({
  required double t1ABonus,
  required double t2ABonus,
  required double t1BBonus,
  required double t2BBonus,
  required double t1TeamBonus,
  required double t2TeamBonus,
  List<HoleMatchupResult> holeResults = const [],
}) {
  return MatchupResult(
    matchup: _matchup,
    team1: _team1,
    team2: _team2,
    team1AMember: _a1,
    team2AMember: _a2,
    team1BMember: _b1,
    team2BMember: _b2,
    holeNumbers: const [1, 2, 3, 4, 5, 6, 7, 8, 9],
    holeResults: holeResults,
    bonusAPoints: PointResult(team1Points: t1ABonus, team2Points: t2ABonus),
    bonusBPoints: PointResult(team1Points: t1BBonus, team2Points: t2BBonus),
    bonusTeamPoints: PointResult(
      team1Points: t1TeamBonus,
      team2Points: t2TeamBonus,
    ),
  );
}

HoleMatchupResult _makeHole({
  required int hole,
  required double t1ANet,
  required double t2ANet,
  required double t1BNet,
  required double t2BNet,
  required double t1APts,
  required double t2APts,
  required double t1BPts,
  required double t2BPts,
  required double t1TPts,
  required double t2TPts,
}) {
  return HoleMatchupResult(
    holeNumber: hole,
    team1ANet: t1ANet.toInt(),
    team2ANet: t2ANet.toInt(),
    team1BNet: t1BNet.toInt(),
    team2BNet: t2BNet.toInt(),
    team1TeamNet: (t1ANet + t1BNet).toInt(),
    team2TeamNet: (t2ANet + t2BNet).toInt(),
    aPoints: PointResult(team1Points: t1APts, team2Points: t2APts),
    bPoints: PointResult(team1Points: t1BPts, team2Points: t2BPts),
    teamPoints: PointResult(team1Points: t1TPts, team2Points: t2TPts),
  );
}

void main() {
  group('HoleMatchupResult', () {
    test('team1HoleTotal sums all team-1 points', () {
      final hole = _makeHole(
        hole: 1,
        t1ANet: 3,
        t2ANet: 4,
        t1BNet: 5,
        t2BNet: 5,
        t1APts: 2,
        t2APts: 0,
        t1BPts: 1,
        t2BPts: 1,
        t1TPts: 1,
        t2TPts: 0,
      );
      expect(hole.team1HoleTotal, closeTo(4.0, 0.001)); // 2+1+1
    });

    test('team2HoleTotal sums all team-2 points', () {
      final hole = _makeHole(
        hole: 1,
        t1ANet: 3,
        t2ANet: 4,
        t1BNet: 5,
        t2BNet: 5,
        t1APts: 2,
        t2APts: 0,
        t1BPts: 1,
        t2BPts: 1,
        t1TPts: 1,
        t2TPts: 0,
      );
      expect(hole.team2HoleTotal, closeTo(1.0, 0.001)); // 0+1+0
    });

    test('per-hole total always sums to 5', () {
      final hole = _makeHole(
        hole: 1,
        t1ANet: 3,
        t2ANet: 4,
        t1BNet: 5,
        t2BNet: 6,
        t1APts: 2,
        t2APts: 0,
        t1BPts: 2,
        t2BPts: 0,
        t1TPts: 1,
        t2TPts: 0,
      );
      expect(hole.team1HoleTotal + hole.team2HoleTotal, closeTo(5.0, 0.001));
    });
  });

  group('MatchupResult', () {
    test('team1GrandTotal sums holes + bonus', () {
      final hole = _makeHole(
        hole: 1,
        t1ANet: 3,
        t2ANet: 4,
        t1BNet: 5,
        t2BNet: 5,
        t1APts: 2,
        t2APts: 0,
        t1BPts: 1,
        t2BPts: 1,
        t1TPts: 1,
        t2TPts: 0,
      );
      final result = _makeResult(
        t1ABonus: 2,
        t2ABonus: 0,
        t1BBonus: 1,
        t2BBonus: 1,
        t1TeamBonus: 1,
        t2TeamBonus: 0,
        holeResults: [hole],
      );
      // hole: 4.0 + bonus: 4.0 = 8.0
      expect(result.team1GrandTotal, closeTo(8.0, 0.001));
    });

    test('team1GrandTotal + team2GrandTotal == 50 with full 9-hole data', () {
      // Fabricate 9 holes where team-1 wins every point
      final holes = List.generate(
        9,
        (i) => _makeHole(
          hole: i + 1,
          t1ANet: 3,
          t2ANet: 4,
          t1BNet: 4,
          t2BNet: 5,
          t1APts: 2,
          t2APts: 0,
          t1BPts: 2,
          t2BPts: 0,
          t1TPts: 1,
          t2TPts: 0,
        ),
      );
      final result = _makeResult(
        t1ABonus: 2,
        t2ABonus: 0,
        t1BBonus: 2,
        t2BBonus: 0,
        t1TeamBonus: 1,
        t2TeamBonus: 0,
        holeResults: holes,
      );
      expect(
        result.team1GrandTotal + result.team2GrandTotal,
        closeTo(50.0, 0.001),
      );
    });

    group('MatchupOutcome', () {
      test('team1Outcome is win when team1GrandTotal > team2GrandTotal', () {
        final result = _makeResult(
          t1ABonus: 2,
          t2ABonus: 0,
          t1BBonus: 2,
          t2BBonus: 0,
          t1TeamBonus: 1,
          t2TeamBonus: 0,
        );
        expect(result.team1Outcome, MatchupOutcome.win);
        expect(result.team2Outcome, MatchupOutcome.loss);
      });

      test('team1Outcome is loss when team1GrandTotal < team2GrandTotal', () {
        final result = _makeResult(
          t1ABonus: 0,
          t2ABonus: 2,
          t1BBonus: 0,
          t2BBonus: 2,
          t1TeamBonus: 0,
          t2TeamBonus: 1,
        );
        expect(result.team1Outcome, MatchupOutcome.loss);
        expect(result.team2Outcome, MatchupOutcome.win);
      });

      test('team1Outcome is tie when totals are equal', () {
        final result = _makeResult(
          t1ABonus: 1,
          t2ABonus: 1,
          t1BBonus: 1,
          t2BBonus: 1,
          t1TeamBonus: 0.5,
          t2TeamBonus: 0.5,
        );
        expect(result.team1Outcome, MatchupOutcome.tie);
        expect(result.team2Outcome, MatchupOutcome.tie);
      });
    });
  });
}
