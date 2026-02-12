import 'package:greenie/course/infrastructure/course_repository.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_providers.g.dart';

@riverpod
Future<List<CourseModel>> fetchCourses(Ref ref) async {
  final courseRepository = ref.watch(courseRepositoryProvider);
  return courseRepository.fetchCourses();
}
