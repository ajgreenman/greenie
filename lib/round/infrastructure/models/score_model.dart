class ScoreModel {
  const ScoreModel({required this.memberId, required this.holeScores});

  final String memberId;

  /// Map from hole number to strokes.
  final Map<int, int> holeScores;

  int get totalStrokes =>
      holeScores.values.fold(0, (total, strokes) => total + strokes);
}
