import 'package:greenie/round/infrastructure/models/score_model.dart';

/// Returns a map of hole number to the member ID who won the skin.
/// A skin is won when a player has the uniquely lowest score on a hole.
/// If there's a tie for lowest, no skin is awarded for that hole.
Map<int, String?> calculateSkins(
  List<ScoreModel> scores,
  List<int> holeNumbers,
) {
  final skins = <int, String?>{};
  for (final holeNumber in holeNumbers) {
    final holeScores = <String, int>{};
    for (final score in scores) {
      final strokes = score.holeScores[holeNumber];
      if (strokes != null) {
        holeScores[score.memberId] = strokes;
      }
    }
    if (holeScores.isEmpty) {
      skins[holeNumber] = null;
      continue;
    }
    final minScore = holeScores.values.reduce((a, b) => a < b ? a : b);
    final winners = holeScores.entries
        .where((e) => e.value == minScore)
        .toList();
    skins[holeNumber] = winners.length == 1 ? winners.first.key : null;
  }
  return skins;
}
