class HoleModel {
  HoleModel({
    required this.number,
    required this.par,
    required this.yardage,
    required this.handicapIndex,
  });

  final int number;
  final int par;

  /// Yardage from the white/middle tees.
  final int yardage;

  /// Stroke index (1 = hardest, 18 = easiest).
  final int handicapIndex;
}
