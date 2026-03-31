import 'package:greenie/course/infrastructure/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'course_repository.g.dart';

@riverpod
CourseRepository courseRepository(Ref ref) {
  throw UnimplementedError(
    'courseRepositoryProvider must be overridden via ProviderScope. '
    'Launch the app via main.dart or main_development.dart.',
  );
}

abstract class CourseRepository {
  Future<List<CourseModel>> fetchCourses();
  Future<CourseModel?> fetchCourse(String id);
}
