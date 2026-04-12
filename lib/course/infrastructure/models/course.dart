import 'package:greenie/course/infrastructure/models/hole.dart';

class CourseModel {
  const CourseModel({
    required this.id,
    required this.name,
    required this.holes,
    this.rating,
    this.slope,
  });

  final String id;
  final String name;
  final List<HoleModel> holes;

  /// Course rating from the white/middle tees (e.g. 66.1).
  final double? rating;

  /// Slope rating from the white/middle tees (e.g. 116).
  final int? slope;

  int get totalPar => holes.fold(0, (total, hole) => total + hole.par);
}
