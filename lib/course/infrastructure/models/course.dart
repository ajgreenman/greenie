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

  /// Course rating from the blue tees (e.g. 70.0).
  final double? rating;

  /// Slope rating from the blue tees (e.g. 128).
  final int? slope;

  int get totalPar => holes.fold(0, (total, hole) => total + hole.par);
}
