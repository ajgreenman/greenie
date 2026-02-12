import 'package:greenie/course/infrastructure/models/hole.dart';

class CourseModel {
  const CourseModel({
    required this.id,
    required this.name,
    required this.holes,
  });

  final String id;
  final String name;

  final List<HoleModel> holes;

  int get totalPar => holes.fold(0, (total, hole) => total + hole.par);
}
