import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/course/infrastructure/fake_course_repository.dart';

void main() {
  late FakeCourseRepository repo;

  setUp(() {
    repo = FakeCourseRepository();
  });

  group('FakeCourseRepository', () {
    test('fetchCourses returns 3 courses', () async {
      final courses = await repo.fetchCourses();
      expect(courses.length, 3);
    });

    test('fetchCourse returns existing course by id', () async {
      final course = await repo.fetchCourse('course-1');
      expect(course, isNotNull);
      expect(course!.name, 'Crown');
    });

    test('fetchCourse returns null for unknown id', () async {
      final course = await repo.fetchCourse('unknown');
      expect(course, isNull);
    });

    test('each course has 18 holes', () async {
      final courses = await repo.fetchCourses();
      for (final course in courses) {
        expect(course.holes.length, 18);
      }
    });

    test('courses have unique IDs', () async {
      final courses = await repo.fetchCourses();
      final ids = courses.map((c) => c.id).toSet();
      expect(ids.length, courses.length);
    });
  });
}
