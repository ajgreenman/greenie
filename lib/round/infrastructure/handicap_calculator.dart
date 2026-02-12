/// Calculates the number of handicap strokes a player receives per hole.
///
/// Distributes [handicap] strokes across [holeCount] holes as evenly as
/// possible, giving extra strokes starting from hole 1.
/// Returns a map from hole number (1-indexed) to strokes received.
Map<int, int> calculateHandicapStrokes(int handicap, List<int> holeNumbers) {
  final holeCount = holeNumbers.length;
  if (holeCount == 0) return {};

  final baseStrokes = handicap ~/ holeCount;
  final extraStrokes = handicap % holeCount;
  final sorted = [...holeNumbers]..sort();

  final result = <int, int>{};
  for (var i = 0; i < sorted.length; i++) {
    result[sorted[i]] = baseStrokes + (i < extraStrokes ? 1 : 0);
  }
  return result;
}

/// Calculates net score for a player on a specific hole.
int netScore(int grossScore, int handicapStrokes) {
  return grossScore - handicapStrokes;
}
