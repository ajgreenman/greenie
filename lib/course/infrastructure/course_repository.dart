import 'package:greenie/course/infrastructure/fake_course_repository.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_repository.g.dart';

@riverpod
CourseRepository courseRepository(Ref ref) {
  return FakeCourseRepository();
}

abstract class CourseRepository {
  Future<List<CourseModel>> fetchCourses();
}
