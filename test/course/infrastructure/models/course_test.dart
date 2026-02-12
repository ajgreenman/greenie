import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';

void main() {
  group('CourseModel', () {
    test('totalPar sums all hole pars', () {
      final course = CourseModel(
        id: 'c1',
        name: 'Test Course',
        holes: [
          HoleModel(number: 1, par: 3),
          HoleModel(number: 2, par: 4),
          HoleModel(number: 3, par: 5),
        ],
      );
      expect(course.totalPar, 12);
    });

    test('totalPar is zero for empty holes', () {
      final course = CourseModel(id: 'c1', name: 'Empty', holes: []);
      expect(course.totalPar, 0);
    });

    test('stores id, name, and holes', () {
      final holes = [HoleModel(number: 1, par: 4)];
      final course = CourseModel(id: 'c1', name: 'My Course', holes: holes);
      expect(course.id, 'c1');
      expect(course.name, 'My Course');
      expect(course.holes, holes);
    });
  });

  group('HoleModel', () {
    test('stores number and par', () {
      final hole = HoleModel(number: 7, par: 5);
      expect(hole.number, 7);
      expect(hole.par, 5);
    });
  });
}
