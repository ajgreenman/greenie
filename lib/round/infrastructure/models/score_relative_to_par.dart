enum ScoreRelativeToPar {
  eagle,
  birdie,
  par,
  bogey,
  doubleBogey,
  triplePlus;

  static ScoreRelativeToPar fromDifference(int difference) {
    if (difference <= -2) return ScoreRelativeToPar.eagle;
    if (difference == -1) return ScoreRelativeToPar.birdie;
    if (difference == 0) return ScoreRelativeToPar.par;
    if (difference == 1) return ScoreRelativeToPar.bogey;
    if (difference == 2) return ScoreRelativeToPar.doubleBogey;
    return ScoreRelativeToPar.triplePlus;
  }

  String get displayName {
    switch (this) {
      case ScoreRelativeToPar.eagle:
        return 'Eagle';
      case ScoreRelativeToPar.birdie:
        return 'Birdie';
      case ScoreRelativeToPar.par:
        return 'Par';
      case ScoreRelativeToPar.bogey:
        return 'Bogey';
      case ScoreRelativeToPar.doubleBogey:
        return 'Double Bogey';
      case ScoreRelativeToPar.triplePlus:
        return 'Triple+';
    }
  }
}
