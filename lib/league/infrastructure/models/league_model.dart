import 'package:greenie/app/core/enums/day_of_the_week.dart';
import 'package:greenie/course/infrastructure/models/course.dart';

class LeagueModel {
  const LeagueModel({
    required this.id,
    required this.name,
    required this.course,
    required this.day,
    required this.memberIds,
    required this.adminId,
  });

  final String id;
  final String name;
  final CourseModel course;
  final DayOfTheWeek day;
  final List<String> memberIds;
  final String adminId;
}
