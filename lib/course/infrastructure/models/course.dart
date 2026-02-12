import 'package:greenie/course/infrastructure/models/hole.dart';

class CourseModel {
  CourseModel({required this.name, required this.holes});

  final String name;

  final List<HoleModel> holes;

  int get totalPar => holes.fold(0, (total, hole) => total + hole.par);
}
