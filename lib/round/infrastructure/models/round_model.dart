import 'package:greenie/round/infrastructure/models/matchup_model.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';
import 'package:greenie/round/infrastructure/models/score_model.dart';

class RoundModel {
  const RoundModel({
    required this.id,
    required this.leagueId,
    required this.courseId,
    required this.date,
    required this.status,
    required this.holeNumbers,
    required this.scores,
    required this.matchups,
    this.startTime,
    this.teamTeeTimes,
  });

  final String id;
  final String leagueId;
  final String courseId;
  final DateTime date;
  final RoundStatus status;

  /// Subset of hole numbers played (e.g. [1..9] for front 9).
  final List<int> holeNumbers;

  final List<ScoreModel> scores;
  final List<MatchupModel> matchups;

  /// Optional tee time for the round (e.g. 5:30 PM on the round's date).
  final DateTime? startTime;

  /// Per-team tee times keyed by teamId. Teams absent use [startTime].
  final Map<String, DateTime>? teamTeeTimes;

  RoundModel copyWith({
    RoundStatus? status,
    List<ScoreModel>? scores,
    List<MatchupModel>? matchups,
    List<int>? holeNumbers,
    DateTime? startTime,
    Map<String, DateTime>? teamTeeTimes,
  }) {
    return RoundModel(
      id: id,
      leagueId: leagueId,
      courseId: courseId,
      date: date,
      status: status ?? this.status,
      holeNumbers: holeNumbers ?? this.holeNumbers,
      scores: scores ?? this.scores,
      matchups: matchups ?? this.matchups,
      startTime: startTime ?? this.startTime,
      teamTeeTimes: teamTeeTimes ?? this.teamTeeTimes,
    );
  }
}
