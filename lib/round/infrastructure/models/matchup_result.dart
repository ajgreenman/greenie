import 'package:greenie/league/infrastructure/models/team_model.dart';
import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

enum MatchupOutcome { win, loss, tie }

class PointResult {
  const PointResult({required this.team1Points, required this.team2Points});

  final double team1Points;
  final double team2Points;
}

class HoleMatchupResult {
  const HoleMatchupResult({
    required this.holeNumber,
    required this.team1ANet,
    required this.team2ANet,
    required this.team1BNet,
    required this.team2BNet,
    required this.team1TeamNet,
    required this.team2TeamNet,
    required this.aPoints,
    required this.bPoints,
    required this.teamPoints,
  });

  final int holeNumber;
  final int team1ANet;
  final int team2ANet;
  final int team1BNet;
  final int team2BNet;
  final int team1TeamNet;
  final int team2TeamNet;
  final PointResult aPoints;
  final PointResult bPoints;
  final PointResult teamPoints;

  double get team1HoleTotal =>
      aPoints.team1Points + bPoints.team1Points + teamPoints.team1Points;

  double get team2HoleTotal =>
      aPoints.team2Points + bPoints.team2Points + teamPoints.team2Points;
}

class MatchupResult {
  const MatchupResult({
    required this.matchup,
    required this.team1,
    required this.team2,
    required this.team1AMember,
    required this.team2AMember,
    required this.team1BMember,
    required this.team2BMember,
    required this.holeNumbers,
    required this.holeResults,
    required this.bonusAPoints,
    required this.bonusBPoints,
    required this.bonusTeamPoints,
  });

  final MatchupModel matchup;
  final TeamModel team1;
  final TeamModel team2;
  final MemberModel team1AMember;
  final MemberModel team2AMember;
  final MemberModel team1BMember;
  final MemberModel team2BMember;

  /// All hole numbers in the round (including incomplete holes).
  final List<int> holeNumbers;
  final List<HoleMatchupResult> holeResults;
  final PointResult bonusAPoints;
  final PointResult bonusBPoints;
  final PointResult bonusTeamPoints;

  double get team1GrandTotal {
    final holeTotal = holeResults.fold(0.0, (sum, h) => sum + h.team1HoleTotal);
    return holeTotal +
        bonusAPoints.team1Points +
        bonusBPoints.team1Points +
        bonusTeamPoints.team1Points;
  }

  double get team2GrandTotal {
    final holeTotal = holeResults.fold(0.0, (sum, h) => sum + h.team2HoleTotal);
    return holeTotal +
        bonusAPoints.team2Points +
        bonusBPoints.team2Points +
        bonusTeamPoints.team2Points;
  }

  MatchupOutcome get team1Outcome {
    if (team1GrandTotal > team2GrandTotal) return MatchupOutcome.win;
    if (team1GrandTotal < team2GrandTotal) return MatchupOutcome.loss;
    return MatchupOutcome.tie;
  }

  MatchupOutcome get team2Outcome {
    if (team2GrandTotal > team1GrandTotal) return MatchupOutcome.win;
    if (team2GrandTotal < team1GrandTotal) return MatchupOutcome.loss;
    return MatchupOutcome.tie;
  }
}
