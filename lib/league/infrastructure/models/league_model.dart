import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/models/course.dart';

class LeagueModel {
  LeagueModel({required this.name, required this.course, required this.day});

  final String name;
  final CourseModel course;
  final DayOfTheWeek day;
}
