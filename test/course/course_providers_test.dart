import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/course/course_providers.dart';

void main() {
  group('Course Providers', () {
    test('fetchCoursesProvider returns courses from fake repository', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final courses = await container.read(fetchCoursesProvider.future);
      expect(courses, isNotEmpty);
      expect(courses.length, 3);
    });

    test('fetchCourseProvider returns a course by id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final courses = await container.read(fetchCoursesProvider.future);
      final firstId = courses.first.id;

      final course = await container.read(fetchCourseProvider(firstId).future);
      expect(course, isNotNull);
      expect(course!.name, courses.first.name);
    });

    test('fetchCourseProvider returns null for unknown id', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final course = await container.read(
        fetchCourseProvider('unknown').future,
      );
      expect(course, isNull);
    });
  });
}
