import 'package:greenie/course/infrastructure/infrastructure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_providers.g.dart';

@riverpod
Future<List<CourseModel>> fetchCourses(Ref ref) async {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return courseRepository.fetchCourses();
}

@riverpod
Future<CourseModel?> fetchCourse(Ref ref, String courseId) async {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return courseRepository.fetchCourse(courseId);
}
