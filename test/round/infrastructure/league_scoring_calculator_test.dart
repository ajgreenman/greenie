import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/round/infrastructure/league_scoring_calculator.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_result.dart';
import 'package:greenie/round/infrastructure/models/round_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

// ── Test fixtures ──────────────────────────────────────────────────────────

const _memberA1 = MemberModel(id: 'a1', name: 'Alice One', handicap: 2);
const _memberB1 = MemberModel(id: 'b1', name: 'Bob One', handicap: 14);
const _memberA2 = MemberModel(id: 'a2', name: 'Alice Two', handicap: 5);
const _memberB2 = MemberModel(id: 'b2', name: 'Bob Two', handicap: 10);
const _allMembers = [_memberA1, _memberB1, _memberA2, _memberB2];

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

// Holes 1–9 with equal stroke distribution
const _holes = [1, 2, 3, 4, 5, 6, 7, 8, 9];

// Complete 9-hole scores where team-1's A player (hdcp 2) beats team-2's A (hdcp 5)
// and B players are closer.
final _completeScores = [
  // a1 (hdcp 2) — strong round
  const ScoreModel(
    memberId: 'a1',
    holeScores: {1: 4, 2: 3, 3: 4, 4: 4, 5: 3, 6: 4, 7: 4, 8: 3, 9: 4},
  ),
  // b1 (hdcp 14) — high handicapper
  const ScoreModel(
    memberId: 'b1',
    holeScores: {1: 6, 2: 5, 3: 5, 4: 6, 5: 5, 6: 5, 7: 6, 8: 5, 9: 5},
  ),
  // a2 (hdcp 5) — slightly worse than a1
  const ScoreModel(
    memberId: 'a2',
    holeScores: {1: 4, 2: 3, 3: 5, 4: 5, 5: 4, 6: 4, 7: 5, 8: 4, 9: 4},
  ),
  // b2 (hdcp 10) — moderate
  const ScoreModel(
    memberId: 'b2',
    holeScores: {1: 5, 2: 4, 3: 5, 4: 5, 5: 5, 6: 5, 7: 5, 8: 4, 9: 5},
  ),
];

// ── Helpers ────────────────────────────────────────────────────────────────

MatchupResult _calculate({List<ScoreModel>? scores}) {
  return calculateMatchupResult(
    matchup: _matchup,
    team1: _team1,
    team2: _team2,
    members: _allMembers,
    scores: scores ?? _completeScores,
    holeNumbers: _holes,
  );
}

// ── Tests ──────────────────────────────────────────────────────────────────

void main() {
  group('calculateMatchupResult', () {
    group('A/B assignment', () {
      test('lower handicap member is A player', () {
        final result = _calculate();
        // team-1: a1 (hdcp 2) < b1 (hdcp 14) → a1 is A
        expect(result.team1AMember.id, 'a1');
        expect(result.team1BMember.id, 'b1');
        // team-2: a2 (hdcp 5) < b2 (hdcp 10) → a2 is A
        expect(result.team2AMember.id, 'a2');
        expect(result.team2BMember.id, 'b2');
      });

      test('tie handicap → list order (index 0 = A)', () {
        const tiedA = MemberModel(id: 'ta', name: 'Tie A', handicap: 8);
        const tiedB = MemberModel(id: 'tb', name: 'Tie B', handicap: 8);
        const teamTied = TeamModel(
          id: 'team-tied',
          leagueId: 'league-1',
          memberIds: ['ta', 'tb'],
          name: 'Tied',
        );
        final result = calculateMatchupResult(
          matchup: _matchup,
          team1: teamTied,
          team2: _team2,
          members: [tiedA, tiedB, _memberA2, _memberB2],
          scores: [
            const ScoreModel(
              memberId: 'ta',
              holeScores: {
                1: 5,
                2: 4,
                3: 5,
                4: 5,
                5: 4,
                6: 5,
                7: 5,
                8: 4,
                9: 5,
              },
            ),
            const ScoreModel(
              memberId: 'tb',
              holeScores: {
                1: 5,
                2: 4,
                3: 5,
                4: 5,
                5: 4,
                6: 5,
                7: 5,
                8: 4,
                9: 5,
              },
            ),
            _completeScores[2],
            _completeScores[3],
          ],
          holeNumbers: _holes,
        );
        // Index 0 (ta) should be A when handicaps are equal
        expect(result.team1AMember.id, 'ta');
        expect(result.team1BMember.id, 'tb');
      });
    });

    group('per-hole scoring', () {
      test('produces 9 hole results for a complete round', () {
        final result = _calculate();
        expect(result.holeResults.length, 9);
      });

      test('each hole has correct hole number', () {
        final result = _calculate();
        final holeNums = result.holeResults.map((h) => h.holeNumber).toList();
        expect(holeNums, _holes);
      });

      test('A-player points sum to 2 per complete hole', () {
        final result = _calculate();
        for (final h in result.holeResults) {
          expect(
            h.aPoints.team1Points + h.aPoints.team2Points,
            closeTo(2.0, 0.001),
          );
        }
      });

      test('B-player points sum to 2 per complete hole', () {
        final result = _calculate();
        for (final h in result.holeResults) {
          expect(
            h.bPoints.team1Points + h.bPoints.team2Points,
            closeTo(2.0, 0.001),
          );
        }
      });

      test('team points sum to 1 per complete hole', () {
        final result = _calculate();
        for (final h in result.holeResults) {
          expect(
            h.teamPoints.team1Points + h.teamPoints.team2Points,
            closeTo(1.0, 0.001),
          );
        }
      });

      test('tie gives 1pt each on A matchup', () {
        // Give both A players identical net scores on every hole
        final result = calculateMatchupResult(
          matchup: _matchup,
          team1: _team1,
          team2: _team2,
          members: _allMembers,
          scores: [
            // a1 (hdcp 2) gross: 4 every hole
            const ScoreModel(
              memberId: 'a1',
              holeScores: {
                1: 4,
                2: 4,
                3: 4,
                4: 4,
                5: 4,
                6: 4,
                7: 4,
                8: 4,
                9: 4,
              },
            ),
            const ScoreModel(
              memberId: 'b1',
              holeScores: {
                1: 5,
                2: 5,
                3: 5,
                4: 5,
                5: 5,
                6: 5,
                7: 5,
                8: 5,
                9: 5,
              },
            ),
            // a2 (hdcp 5) gross: adjusted so net == a1's net on every hole
            // a1 hdcp 2 on 9 holes: 2 extra strokes on holes 1-2, rest 0
            // a2 hdcp 5 on 9 holes: 5 extra strokes on holes 1-5, rest 0
            // To tie: a2 net == a1 net each hole
            // hole 1: a1 gross=4, strokes=1 → net=3; a2 strokes=1 → gross=4 net=3 ✓
            // hole 2: a1 gross=4, strokes=1 → net=3; a2 strokes=1 → gross=4 net=3 ✓
            // hole 3: a1 gross=4, strokes=0 → net=4; a2 strokes=1 → gross=5 net=4 ✓
            // hole 4: a1 gross=4, strokes=0 → net=4; a2 strokes=1 → gross=5 net=4 ✓
            // hole 5: a1 gross=4, strokes=0 → net=4; a2 strokes=1 → gross=5 net=4 ✓
            // hole 6-9: a1 strokes=0 → net=4; a2 strokes=0 → gross=4 net=4 ✓
            const ScoreModel(
              memberId: 'a2',
              holeScores: {
                1: 4,
                2: 4,
                3: 5,
                4: 5,
                5: 5,
                6: 4,
                7: 4,
                8: 4,
                9: 4,
              },
            ),
            const ScoreModel(
              memberId: 'b2',
              holeScores: {
                1: 5,
                2: 5,
                3: 5,
                4: 5,
                5: 5,
                6: 5,
                7: 5,
                8: 5,
                9: 5,
              },
            ),
          ],
          holeNumbers: _holes,
        );
        for (final h in result.holeResults) {
          expect(h.aPoints.team1Points, closeTo(1.0, 0.001));
          expect(h.aPoints.team2Points, closeTo(1.0, 0.001));
        }
      });
    });

    group('grand total invariant', () {
      test('grand totals sum to 50 for a complete 9-hole round', () {
        final result = _calculate();
        expect(
          result.team1GrandTotal + result.team2GrandTotal,
          closeTo(50.0, 0.001),
        );
      });
    });

    group('partial round (in-progress)', () {
      test('only complete holes are counted', () {
        // 4-hole partial scores
        final result = calculateMatchupResult(
          matchup: _matchup,
          team1: _team1,
          team2: _team2,
          members: _allMembers,
          scores: [
            const ScoreModel(
              memberId: 'a1',
              holeScores: {1: 4, 2: 3, 3: 4, 4: 4},
            ),
            const ScoreModel(
              memberId: 'b1',
              holeScores: {1: 6, 2: 5, 3: 5, 4: 6},
            ),
            const ScoreModel(
              memberId: 'a2',
              holeScores: {1: 4, 2: 3, 3: 5, 4: 5},
            ),
            const ScoreModel(
              memberId: 'b2',
              holeScores: {1: 5, 2: 4, 3: 5, 4: 5},
            ),
          ],
          holeNumbers: _holes,
        );
        expect(result.holeResults.length, 4);
        // Bonus is computed on complete holes only → total < 50
        expect(result.team1GrandTotal + result.team2GrandTotal, lessThan(50));
      });

      test('gracefully handles one player with no scores', () {
        final result = calculateMatchupResult(
          matchup: _matchup,
          team1: _team1,
          team2: _team2,
          members: _allMembers,
          scores: [
            const ScoreModel(memberId: 'a1', holeScores: {1: 4, 2: 3, 3: 4}),
            // b1 has no scores
            const ScoreModel(memberId: 'a2', holeScores: {1: 4, 2: 3, 3: 5}),
            const ScoreModel(memberId: 'b2', holeScores: {1: 5, 2: 4, 3: 5}),
          ],
          holeNumbers: _holes,
        );
        // No complete holes (b1 missing)
        expect(result.holeResults, isEmpty);
      });
    });

    group('bonus points', () {
      test('bonus A/B/team points sum to 5', () {
        final result = _calculate();
        final bonusTotal =
            result.bonusAPoints.team1Points +
            result.bonusAPoints.team2Points +
            result.bonusBPoints.team1Points +
            result.bonusBPoints.team2Points +
            result.bonusTeamPoints.team1Points +
            result.bonusTeamPoints.team2Points;
        expect(bonusTotal, closeTo(5.0, 0.001));
      });
    });
  });

  group('calculateStandings', () {
    final teams = [_team1, _team2];

    RoundModel makeRound({
      required String id,
      required List<ScoreModel> scores,
      RoundStatus status = RoundStatus.completed,
    }) {
      return RoundModel(
        id: id,
        leagueId: 'league-1',
        courseId: 'course-1',
        date: DateTime(2025, 6, 1),
        status: status,
        holeNumbers: _holes,
        scores: scores,
        matchups: [_matchup],
      );
    }

    test('returns one standing per team', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [makeRound(id: 'r1', scores: _completeScores)],
        members: _allMembers,
      );
      expect(standings.length, 2);
    });

    test('winner accumulates a win and loser a loss', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [makeRound(id: 'r1', scores: _completeScores)],
        members: _allMembers,
      );
      final result = _calculate();
      final winnerStanding = standings.firstWhere(
        (s) =>
            s.team.id ==
            (result.team1Outcome == MatchupOutcome.win ? 'team-1' : 'team-2'),
      );
      final loserStanding = standings.firstWhere(
        (s) =>
            s.team.id ==
            (result.team1Outcome == MatchupOutcome.win ? 'team-2' : 'team-1'),
      );
      expect(winnerStanding.wins, 1);
      expect(winnerStanding.losses, 0);
      expect(loserStanding.wins, 0);
      expect(loserStanding.losses, 1);
    });

    test('standings sorted by total points descending', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [makeRound(id: 'r1', scores: _completeScores)],
        members: _allMembers,
      );
      expect(standings.first.totalPoints >= standings.last.totalPoints, isTrue);
    });

    test('rank 1 assigned to leader', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [makeRound(id: 'r1', scores: _completeScores)],
        members: _allMembers,
      );
      expect(standings.first.rank, 1);
    });

    test('skips non-completed rounds', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [
          makeRound(
            id: 'r1',
            scores: _completeScores,
            status: RoundStatus.inProgress,
          ),
        ],
        members: _allMembers,
      );
      // inProgress round skipped → no wins/losses
      for (final s in standings) {
        expect(s.roundsPlayed, 0);
      }
    });

    test('accumulates across multiple rounds', () {
      final standings = calculateStandings(
        teams: teams,
        completedRounds: [
          makeRound(id: 'r1', scores: _completeScores),
          makeRound(id: 'r2', scores: _completeScores),
        ],
        members: _allMembers,
      );
      final total = standings.fold(0, (sum, s) => sum + s.roundsPlayed);
      expect(total, 4); // 2 teams × 2 rounds
    });
  });
}
