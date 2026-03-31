import 'package:greenie/league/infrastructure/models/models.dart';
import 'package:greenie/round/infrastructure/handicap_calculator.dart';
import 'package:greenie/round/infrastructure/models/models.dart';
import 'package:greenie/user/infrastructure/models/models.dart';

/// Calculates the full point breakdown for a single matchup.
///
/// Per hole (5 pts total):
///   A vs A net → 2 pts (lower wins, tie = 1 each)
///   B vs B net → 2 pts (lower wins, tie = 1 each)
///   Team combined net → 1 pt (lower wins, tie = 0.5 each)
///
/// Round bonus (5 pts): same 3-way comparison on full-round net totals.
/// Total for a 9-hole round: 50 pts.
MatchupResult calculateMatchupResult({
  required MatchupModel matchup,
  required TeamModel team1,
  required TeamModel team2,
  required List<MemberModel> members,
  required List<ScoreModel> scores,
  required List<int> holeNumbers,
}) {
  // Resolve members for each team
  MemberModel resolveMember(String id) => members.firstWhere((m) => m.id == id);
  final t1m0 = resolveMember(team1.memberIds[0]);
  final t1m1 = resolveMember(team1.memberIds[1]);
  final t2m0 = resolveMember(team2.memberIds[0]);
  final t2m1 = resolveMember(team2.memberIds[1]);

  // Assign A/B: lower handicap = A. Tie → list order (index 0 = A).
  final team1A = t1m0.handicap <= t1m1.handicap ? t1m0 : t1m1;
  final team1B = team1A == t1m0 ? t1m1 : t1m0;
  final team2A = t2m0.handicap <= t2m1.handicap ? t2m0 : t2m1;
  final team2B = team2A == t2m0 ? t2m1 : t2m0;

  // Handicap strokes per hole for all 4 players
  final t1AStrokes = calculateHandicapStrokes(team1A.handicap, holeNumbers);
  final t1BStrokes = calculateHandicapStrokes(team1B.handicap, holeNumbers);
  final t2AStrokes = calculateHandicapStrokes(team2A.handicap, holeNumbers);
  final t2BStrokes = calculateHandicapStrokes(team2B.handicap, holeNumbers);

  ScoreModel? resolveScore(String memberId) =>
      scores.where((s) => s.memberId == memberId).firstOrNull;

  final t1AScore = resolveScore(team1A.id);
  final t1BScore = resolveScore(team1B.id);
  final t2AScore = resolveScore(team2A.id);
  final t2BScore = resolveScore(team2B.id);

  // Build per-hole results — skip holes where any player has no gross score.
  final holeResults = <HoleMatchupResult>[];
  for (final hole in holeNumbers) {
    final t1AGross = t1AScore?.holeScores[hole];
    final t1BGross = t1BScore?.holeScores[hole];
    final t2AGross = t2AScore?.holeScores[hole];
    final t2BGross = t2BScore?.holeScores[hole];
    if (t1AGross == null ||
        t1BGross == null ||
        t2AGross == null ||
        t2BGross == null) {
      continue;
    }

    final t1ANet = netScore(t1AGross, t1AStrokes[hole] ?? 0);
    final t1BNet = netScore(t1BGross, t1BStrokes[hole] ?? 0);
    final t2ANet = netScore(t2AGross, t2AStrokes[hole] ?? 0);
    final t2BNet = netScore(t2BGross, t2BStrokes[hole] ?? 0);

    holeResults.add(
      HoleMatchupResult(
        holeNumber: hole,
        team1ANet: t1ANet,
        team2ANet: t2ANet,
        team1BNet: t1BNet,
        team2BNet: t2BNet,
        team1TeamNet: t1ANet + t1BNet,
        team2TeamNet: t2ANet + t2BNet,
        aPoints: _awardPoints(t1ANet, t2ANet, 2.0),
        bPoints: _awardPoints(t1BNet, t2BNet, 2.0),
        teamPoints: _awardPoints(t1ANet + t1BNet, t2ANet + t2BNet, 1.0),
      ),
    );
  }

  // Round bonus: sum nets across all complete holes.
  var t1ATotal = 0;
  var t1BTotal = 0;
  var t2ATotal = 0;
  var t2BTotal = 0;
  for (final h in holeResults) {
    t1ATotal += h.team1ANet;
    t1BTotal += h.team1BNet;
    t2ATotal += h.team2ANet;
    t2BTotal += h.team2BNet;
  }

  return MatchupResult(
    matchup: matchup,
    team1: team1,
    team2: team2,
    team1AMember: team1A,
    team2AMember: team2A,
    team1BMember: team1B,
    team2BMember: team2B,
    holeNumbers: holeNumbers,
    holeResults: holeResults,
    bonusAPoints: _awardPoints(t1ATotal, t2ATotal, 2.0),
    bonusBPoints: _awardPoints(t1BTotal, t2BTotal, 2.0),
    bonusTeamPoints: _awardPoints(
      t1ATotal + t1BTotal,
      t2ATotal + t2BTotal,
      1.0,
    ),
  );
}

/// Calculates season standings for all teams.
///
/// Iterates over all completed rounds and their matchups, accumulates
/// wins/losses/ties and point totals per team, then ranks by total points
/// descending (dense ranking — ties share a rank).
List<TeamStanding> calculateStandings({
  required List<TeamModel> teams,
  required List<RoundModel> completedRounds,
  required List<MemberModel> members,
}) {
  // Initialise accumulators
  final wins = <String, int>{};
  final losses = <String, int>{};
  final ties = <String, int>{};
  final points = <String, double>{};
  for (final t in teams) {
    wins[t.id] = 0;
    losses[t.id] = 0;
    ties[t.id] = 0;
    points[t.id] = 0.0;
  }

  for (final round in completedRounds) {
    if (round.status != RoundStatus.completed) continue;
    for (final matchup in round.matchups) {
      final team1 = teams.where((t) => t.id == matchup.team1Id).firstOrNull;
      final team2 = teams.where((t) => t.id == matchup.team2Id).firstOrNull;
      if (team1 == null || team2 == null) continue;

      final result = calculateMatchupResult(
        matchup: matchup,
        team1: team1,
        team2: team2,
        members: members,
        scores: round.scores,
        holeNumbers: round.holeNumbers,
      );

      points[team1.id] = (points[team1.id] ?? 0) + result.team1GrandTotal;
      points[team2.id] = (points[team2.id] ?? 0) + result.team2GrandTotal;

      switch (result.team1Outcome) {
        case MatchupOutcome.win:
          wins[team1.id] = (wins[team1.id] ?? 0) + 1;
          losses[team2.id] = (losses[team2.id] ?? 0) + 1;
        case MatchupOutcome.loss:
          losses[team1.id] = (losses[team1.id] ?? 0) + 1;
          wins[team2.id] = (wins[team2.id] ?? 0) + 1;
        case MatchupOutcome.tie:
          ties[team1.id] = (ties[team1.id] ?? 0) + 1;
          ties[team2.id] = (ties[team2.id] ?? 0) + 1;
      }
    }
  }

  // Build and sort standings
  final standing =
      teams
          .map(
            (t) => TeamStanding(
              team: t,
              wins: wins[t.id] ?? 0,
              losses: losses[t.id] ?? 0,
              ties: ties[t.id] ?? 0,
              totalPoints: points[t.id] ?? 0.0,
              rank: 0,
            ),
          )
          .toList()
        ..sort((a, b) => b.totalPoints.compareTo(a.totalPoints));

  // Dense rank assignment
  var currentRank = 1;
  for (var i = 0; i < standing.length; i++) {
    if (i > 0 && standing[i].totalPoints < standing[i - 1].totalPoints) {
      currentRank = i + 1;
    }
    standing[i] = TeamStanding(
      team: standing[i].team,
      wins: standing[i].wins,
      losses: standing[i].losses,
      ties: standing[i].ties,
      totalPoints: standing[i].totalPoints,
      rank: currentRank,
    );
  }

  return standing;
}

PointResult _awardPoints(num score1, num score2, double maxPts) {
  if (score1 < score2) {
    return PointResult(team1Points: maxPts, team2Points: 0);
  }
  if (score2 < score1) {
    return PointResult(team1Points: 0, team2Points: maxPts);
  }
  return PointResult(team1Points: maxPts / 2, team2Points: maxPts / 2);
}
