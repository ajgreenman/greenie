import 'package:greenie/course/infrastructure/course_repository.dart';
import 'package:greenie/course/infrastructure/models/models.dart';

class FakeCourseRepository extends CourseRepository {
  @override
  Future<List<CourseModel>> fetchCourses() async => courses;

  @override
  Future<CourseModel?> fetchCourse(String id) async =>
      courses.where((c) => c.id == id).firstOrNull;

  static final courses = [
    _crown,
    _elmbrook,
    _theBear,
    _spruceRun,
    _wolverine,
  ];

  // ── The Crown Golf Club — Traverse City, MI ─────────────────────────────
  // White tees | Par 72 | 5,424 yds | Rating 66.1 | Slope 116
  static final _crown = CourseModel(
    id: 'course-1',
    name: 'The Crown Golf Club',
    rating: 66.1,
    slope: 116,
    holes: [
      HoleModel(number: 1,  par: 5, yardage: 396, handicapIndex: 7),
      HoleModel(number: 2,  par: 4, yardage: 328, handicapIndex: 13),
      HoleModel(number: 3,  par: 3, yardage: 119, handicapIndex: 15),
      HoleModel(number: 4,  par: 5, yardage: 475, handicapIndex: 3),
      HoleModel(number: 5,  par: 4, yardage: 330, handicapIndex: 5),
      HoleModel(number: 6,  par: 4, yardage: 356, handicapIndex: 1),
      HoleModel(number: 7,  par: 4, yardage: 296, handicapIndex: 9),
      HoleModel(number: 8,  par: 4, yardage: 327, handicapIndex: 11),
      HoleModel(number: 9,  par: 3, yardage: 155, handicapIndex: 17),
      HoleModel(number: 10, par: 4, yardage: 322, handicapIndex: 6),
      HoleModel(number: 11, par: 4, yardage: 299, handicapIndex: 2),
      HoleModel(number: 12, par: 3, yardage: 129, handicapIndex: 16),
      HoleModel(number: 13, par: 4, yardage: 304, handicapIndex: 12),
      HoleModel(number: 14, par: 5, yardage: 408, handicapIndex: 4),
      HoleModel(number: 15, par: 4, yardage: 239, handicapIndex: 14),
      HoleModel(number: 16, par: 3, yardage: 136, handicapIndex: 18),
      HoleModel(number: 17, par: 5, yardage: 499, handicapIndex: 8),
      HoleModel(number: 18, par: 4, yardage: 306, handicapIndex: 10),
    ],
  );

  // ── Elmbrook Golf Course — Traverse City, MI ─────────────────────────────
  // White tees | Par 72 | 4,938 yds | Rating 63.9 | Slope 103
  static final _elmbrook = CourseModel(
    id: 'course-2',
    name: 'Elmbrook Golf Course',
    rating: 63.9,
    slope: 103,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 302, handicapIndex: 11),
      HoleModel(number: 2,  par: 3, yardage: 142, handicapIndex: 7),
      HoleModel(number: 3,  par: 5, yardage: 388, handicapIndex: 5),
      HoleModel(number: 4,  par: 4, yardage: 268, handicapIndex: 15),
      HoleModel(number: 5,  par: 4, yardage: 271, handicapIndex: 13),
      HoleModel(number: 6,  par: 4, yardage: 340, handicapIndex: 1),
      HoleModel(number: 7,  par: 5, yardage: 417, handicapIndex: 3),
      HoleModel(number: 8,  par: 4, yardage: 264, handicapIndex: 17),
      HoleModel(number: 9,  par: 3, yardage: 142, handicapIndex: 9),
      HoleModel(number: 10, par: 4, yardage: 270, handicapIndex: 18),
      HoleModel(number: 11, par: 5, yardage: 385, handicapIndex: 4),
      HoleModel(number: 12, par: 3, yardage: 154, handicapIndex: 10),
      HoleModel(number: 13, par: 5, yardage: 419, handicapIndex: 2),
      HoleModel(number: 14, par: 3, yardage: 128, handicapIndex: 16),
      HoleModel(number: 15, par: 4, yardage: 236, handicapIndex: 8),
      HoleModel(number: 16, par: 4, yardage: 221, handicapIndex: 6),
      HoleModel(number: 17, par: 4, yardage: 306, handicapIndex: 12),
      HoleModel(number: 18, par: 4, yardage: 285, handicapIndex: 14),
    ],
  );

  // ── The Bear — Grand Traverse Resort, Acme, MI ──────────────────────────
  // White tees | Par 72 | 6,122 yds | Rating 71.1 | Slope 139
  static final _theBear = CourseModel(
    id: 'course-3',
    name: 'The Bear at Grand Traverse Resort',
    rating: 71.1,
    slope: 139,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 340, handicapIndex: 11),
      HoleModel(number: 2,  par: 4, yardage: 390, handicapIndex: 5),
      HoleModel(number: 3,  par: 5, yardage: 472, handicapIndex: 9),
      HoleModel(number: 4,  par: 3, yardage: 135, handicapIndex: 15),
      HoleModel(number: 5,  par: 4, yardage: 376, handicapIndex: 1),
      HoleModel(number: 6,  par: 5, yardage: 471, handicapIndex: 17),
      HoleModel(number: 7,  par: 4, yardage: 364, handicapIndex: 3),
      HoleModel(number: 8,  par: 4, yardage: 351, handicapIndex: 7),
      HoleModel(number: 9,  par: 3, yardage: 142, handicapIndex: 13),
      HoleModel(number: 10, par: 5, yardage: 446, handicapIndex: 2),
      HoleModel(number: 11, par: 4, yardage: 364, handicapIndex: 8),
      HoleModel(number: 12, par: 4, yardage: 355, handicapIndex: 4),
      HoleModel(number: 13, par: 3, yardage: 134, handicapIndex: 18),
      HoleModel(number: 14, par: 4, yardage: 347, handicapIndex: 16),
      HoleModel(number: 15, par: 5, yardage: 494, handicapIndex: 12),
      HoleModel(number: 16, par: 4, yardage: 367, handicapIndex: 6),
      HoleModel(number: 17, par: 3, yardage: 188, handicapIndex: 14),
      HoleModel(number: 18, par: 4, yardage: 386, handicapIndex: 10),
    ],
  );

  // ── Spruce Run — Grand Traverse Resort, Acme, MI ────────────────────────
  // White tees | Par 70 | 5,606 yds | Rating 68.2 | Slope 131
  static final _spruceRun = CourseModel(
    id: 'course-4',
    name: 'Spruce Run at Grand Traverse Resort',
    rating: 68.2,
    slope: 131,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 345, handicapIndex: 9),
      HoleModel(number: 2,  par: 5, yardage: 443, handicapIndex: 7),
      HoleModel(number: 3,  par: 4, yardage: 368, handicapIndex: 5),
      HoleModel(number: 4,  par: 4, yardage: 418, handicapIndex: 1),
      HoleModel(number: 5,  par: 4, yardage: 387, handicapIndex: 3),
      HoleModel(number: 6,  par: 3, yardage: 124, handicapIndex: 17),
      HoleModel(number: 7,  par: 4, yardage: 359, handicapIndex: 13),
      HoleModel(number: 8,  par: 3, yardage: 155, handicapIndex: 15),
      HoleModel(number: 9,  par: 5, yardage: 472, handicapIndex: 11),
      HoleModel(number: 10, par: 3, yardage: 169, handicapIndex: 6),
      HoleModel(number: 11, par: 4, yardage: 325, handicapIndex: 4),
      HoleModel(number: 12, par: 4, yardage: 275, handicapIndex: 14),
      HoleModel(number: 13, par: 4, yardage: 279, handicapIndex: 12),
      HoleModel(number: 14, par: 4, yardage: 333, handicapIndex: 10),
      HoleModel(number: 15, par: 4, yardage: 370, handicapIndex: 8),
      HoleModel(number: 16, par: 3, yardage: 139, handicapIndex: 18),
      HoleModel(number: 17, par: 4, yardage: 289, handicapIndex: 16),
      HoleModel(number: 18, par: 4, yardage: 356, handicapIndex: 2),
    ],
  );

  // ── The Wolverine — Grand Traverse Resort, Acme, MI ─────────────────────
  // White tees | Par 72 | 5,862 yds | Rating 68.6 | Slope 131
  static final _wolverine = CourseModel(
    id: 'course-5',
    name: 'The Wolverine at Grand Traverse Resort',
    rating: 68.6,
    slope: 131,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 328, handicapIndex: 13),
      HoleModel(number: 2,  par: 4, yardage: 354, handicapIndex: 5),
      HoleModel(number: 3,  par: 5, yardage: 444, handicapIndex: 1),
      HoleModel(number: 4,  par: 4, yardage: 334, handicapIndex: 11),
      HoleModel(number: 5,  par: 3, yardage: 147, handicapIndex: 15),
      HoleModel(number: 6,  par: 4, yardage: 332, handicapIndex: 7),
      HoleModel(number: 7,  par: 4, yardage: 357, handicapIndex: 9),
      HoleModel(number: 8,  par: 5, yardage: 452, handicapIndex: 3),
      HoleModel(number: 9,  par: 3, yardage: 128, handicapIndex: 17),
      HoleModel(number: 10, par: 4, yardage: 363, handicapIndex: 4),
      HoleModel(number: 11, par: 5, yardage: 477, handicapIndex: 10),
      HoleModel(number: 12, par: 3, yardage: 154, handicapIndex: 18),
      HoleModel(number: 13, par: 4, yardage: 318, handicapIndex: 8),
      HoleModel(number: 14, par: 3, yardage: 146, handicapIndex: 16),
      HoleModel(number: 15, par: 4, yardage: 308, handicapIndex: 14),
      HoleModel(number: 16, par: 4, yardage: 417, handicapIndex: 2),
      HoleModel(number: 17, par: 4, yardage: 336, handicapIndex: 12),
      HoleModel(number: 18, par: 5, yardage: 467, handicapIndex: 6),
    ],
  );
}
