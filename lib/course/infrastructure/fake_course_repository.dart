import 'package:greenie/course/infrastructure/course_repository.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';

class FakeCourseRepository extends CourseRepository {
  @override
  Future<List<CourseModel>> fetchCourses() async {
    return courses;
  }

  static final courses = [
    CourseModel(
      name: 'Crown',
      holes: [
        HoleModel(number: 1, par: 5),
        HoleModel(number: 2, par: 4),
        HoleModel(number: 3, par: 3),
        HoleModel(number: 4, par: 5),
        HoleModel(number: 5, par: 4),
        HoleModel(number: 6, par: 4),
        HoleModel(number: 7, par: 4),
        HoleModel(number: 8, par: 4),
        HoleModel(number: 9, par: 3),
        HoleModel(number: 10, par: 4),
        HoleModel(number: 11, par: 4),
        HoleModel(number: 12, par: 3),
        HoleModel(number: 13, par: 4),
        HoleModel(number: 14, par: 5),
        HoleModel(number: 15, par: 4),
        HoleModel(number: 16, par: 3),
        HoleModel(number: 17, par: 5),
        HoleModel(number: 18, par: 4),
      ],
    ),
    CourseModel(
      name: 'Elmbrook',
      holes: [
        HoleModel(number: 1, par: 4),
        HoleModel(number: 2, par: 3),
        HoleModel(number: 3, par: 5),
        HoleModel(number: 4, par: 4),
        HoleModel(number: 5, par: 4),
        HoleModel(number: 6, par: 4),
        HoleModel(number: 7, par: 5),
        HoleModel(number: 8, par: 4),
        HoleModel(number: 9, par: 3),
        HoleModel(number: 10, par: 4),
        HoleModel(number: 11, par: 5),
        HoleModel(number: 12, par: 3),
        HoleModel(number: 13, par: 5),
        HoleModel(number: 14, par: 3),
        HoleModel(number: 15, par: 4),
        HoleModel(number: 16, par: 4),
        HoleModel(number: 17, par: 4),
        HoleModel(number: 18, par: 4),
      ],
    ),
    CourseModel(
      name: 'Bahle Farms',
      holes: [
        HoleModel(number: 1, par: 4),
        HoleModel(number: 2, par: 5),
        HoleModel(number: 3, par: 4),
        HoleModel(number: 4, par: 3),
        HoleModel(number: 5, par: 5),
        HoleModel(number: 6, par: 3),
        HoleModel(number: 7, par: 4),
        HoleModel(number: 8, par: 4),
        HoleModel(number: 9, par: 3),
        HoleModel(number: 10, par: 4),
        HoleModel(number: 11, par: 3),
        HoleModel(number: 12, par: 5),
        HoleModel(number: 13, par: 4),
        HoleModel(number: 14, par: 4),
        HoleModel(number: 15, par: 3),
        HoleModel(number: 16, par: 5),
        HoleModel(number: 17, par: 4),
        HoleModel(number: 18, par: 4),
      ],
    ),
  ];
}
