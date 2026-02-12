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
  });

  final String id;
  final String leagueId;
  final String courseId;
  final DateTime date;
  final RoundStatus status;

  /// Subset of hole numbers played (e.g. [1..9] for front 9).
  final List<int> holeNumbers;

  final List<ScoreModel> scores;

  RoundModel copyWith({RoundStatus? status, List<ScoreModel>? scores}) {
    return RoundModel(
      id: id,
      leagueId: leagueId,
      courseId: courseId,
      date: date,
      status: status ?? this.status,
      holeNumbers: holeNumbers,
      scores: scores ?? this.scores,
    );
  }
}
