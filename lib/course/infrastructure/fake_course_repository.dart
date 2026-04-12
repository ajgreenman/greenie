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
  // Blue tees | Par 72 | 6,179 yds | Rating 70.0 | Slope 128
  static final _crown = CourseModel(
    id: 'course-1',
    name: 'The Crown Golf Club',
    rating: 70.0,
    slope: 128,
    holes: [
      HoleModel(number: 1,  par: 5, yardage: 494, handicapIndex: 7),
      HoleModel(number: 2,  par: 4, yardage: 373, handicapIndex: 13),
      HoleModel(number: 3,  par: 3, yardage: 130, handicapIndex: 15),
      HoleModel(number: 4,  par: 5, yardage: 494, handicapIndex: 3),
      HoleModel(number: 5,  par: 4, yardage: 368, handicapIndex: 5),
      HoleModel(number: 6,  par: 4, yardage: 402, handicapIndex: 1),
      HoleModel(number: 7,  par: 4, yardage: 306, handicapIndex: 9),
      HoleModel(number: 8,  par: 4, yardage: 358, handicapIndex: 11),
      HoleModel(number: 9,  par: 3, yardage: 169, handicapIndex: 17),
      HoleModel(number: 10, par: 4, yardage: 359, handicapIndex: 6),
      HoleModel(number: 11, par: 4, yardage: 384, handicapIndex: 2),
      HoleModel(number: 12, par: 3, yardage: 151, handicapIndex: 16),
      HoleModel(number: 13, par: 4, yardage: 362, handicapIndex: 12),
      HoleModel(number: 14, par: 5, yardage: 523, handicapIndex: 4),
      HoleModel(number: 15, par: 4, yardage: 292, handicapIndex: 14),
      HoleModel(number: 16, par: 3, yardage: 141, handicapIndex: 18),
      HoleModel(number: 17, par: 5, yardage: 512, handicapIndex: 8),
      HoleModel(number: 18, par: 4, yardage: 361, handicapIndex: 10),
    ],
  );

  // ── Elmbrook Golf Course — Traverse City, MI ─────────────────────────────
  // Blue tees | Par 72 | 5,674 yds | Rating 67.4 | Slope 116
  static final _elmbrook = CourseModel(
    id: 'course-2',
    name: 'Elmbrook Golf Course',
    rating: 67.4,
    slope: 116,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 343, handicapIndex: 11),
      HoleModel(number: 2,  par: 3, yardage: 161, handicapIndex: 7),
      HoleModel(number: 3,  par: 5, yardage: 467, handicapIndex: 5),
      HoleModel(number: 4,  par: 4, yardage: 321, handicapIndex: 15),
      HoleModel(number: 5,  par: 4, yardage: 339, handicapIndex: 13),
      HoleModel(number: 6,  par: 4, yardage: 366, handicapIndex: 1),
      HoleModel(number: 7,  par: 5, yardage: 485, handicapIndex: 3),
      HoleModel(number: 8,  par: 4, yardage: 285, handicapIndex: 17),
      HoleModel(number: 9,  par: 3, yardage: 170, handicapIndex: 9),
      HoleModel(number: 10, par: 4, yardage: 297, handicapIndex: 4),
      HoleModel(number: 11, par: 5, yardage: 468, handicapIndex: 10),
      HoleModel(number: 12, par: 3, yardage: 176, handicapIndex: 2),
      HoleModel(number: 13, par: 5, yardage: 464, handicapIndex: 16),
      HoleModel(number: 14, par: 3, yardage: 143, handicapIndex: 8),
      HoleModel(number: 15, par: 4, yardage: 254, handicapIndex: 6),
      HoleModel(number: 16, par: 4, yardage: 241, handicapIndex: 12),
      HoleModel(number: 17, par: 4, yardage: 357, handicapIndex: 14),
      HoleModel(number: 18, par: 4, yardage: 337, handicapIndex: 18),
    ],
  );

  // ── The Bear — Grand Traverse Resort, Acme, MI ──────────────────────────
  // Blue tees | Par 72 | 6,601 yds | Rating 73.3 | Slope 147
  static final _theBear = CourseModel(
    id: 'course-3',
    name: 'The Bear at Grand Traverse Resort',
    rating: 73.3,
    slope: 147,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 364, handicapIndex: 11),
      HoleModel(number: 2,  par: 4, yardage: 407, handicapIndex: 5),
      HoleModel(number: 3,  par: 5, yardage: 528, handicapIndex: 9),
      HoleModel(number: 4,  par: 3, yardage: 151, handicapIndex: 15),
      HoleModel(number: 5,  par: 4, yardage: 376, handicapIndex: 1),
      HoleModel(number: 6,  par: 5, yardage: 532, handicapIndex: 17),
      HoleModel(number: 7,  par: 4, yardage: 364, handicapIndex: 3),
      HoleModel(number: 8,  par: 4, yardage: 386, handicapIndex: 7),
      HoleModel(number: 9,  par: 3, yardage: 168, handicapIndex: 13),
      HoleModel(number: 10, par: 5, yardage: 505, handicapIndex: 2),
      HoleModel(number: 11, par: 4, yardage: 364, handicapIndex: 8),
      HoleModel(number: 12, par: 4, yardage: 367, handicapIndex: 4),
      HoleModel(number: 13, par: 3, yardage: 150, handicapIndex: 18),
      HoleModel(number: 14, par: 4, yardage: 390, handicapIndex: 16),
      HoleModel(number: 15, par: 5, yardage: 543, handicapIndex: 12),
      HoleModel(number: 16, par: 4, yardage: 391, handicapIndex: 6),
      HoleModel(number: 17, par: 3, yardage: 188, handicapIndex: 14),
      HoleModel(number: 18, par: 4, yardage: 427, handicapIndex: 10),
    ],
  );

  // ── Spruce Run — Grand Traverse Resort, Acme, MI ────────────────────────
  // Blue tees | Par 70 | 6,204 yds | Rating 71.2 | Slope 136
  static final _spruceRun = CourseModel(
    id: 'course-4',
    name: 'Spruce Run at Grand Traverse Resort',
    rating: 71.2,
    slope: 136,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 362, handicapIndex: 9),
      HoleModel(number: 2,  par: 5, yardage: 485, handicapIndex: 7),
      HoleModel(number: 3,  par: 4, yardage: 400, handicapIndex: 5),
      HoleModel(number: 4,  par: 4, yardage: 452, handicapIndex: 1),
      HoleModel(number: 5,  par: 4, yardage: 409, handicapIndex: 3),
      HoleModel(number: 6,  par: 3, yardage: 150, handicapIndex: 17),
      HoleModel(number: 7,  par: 4, yardage: 383, handicapIndex: 13),
      HoleModel(number: 8,  par: 3, yardage: 190, handicapIndex: 15),
      HoleModel(number: 9,  par: 5, yardage: 501, handicapIndex: 11),
      HoleModel(number: 10, par: 3, yardage: 215, handicapIndex: 6),
      HoleModel(number: 11, par: 4, yardage: 362, handicapIndex: 4),
      HoleModel(number: 12, par: 4, yardage: 306, handicapIndex: 14),
      HoleModel(number: 13, par: 4, yardage: 332, handicapIndex: 12),
      HoleModel(number: 14, par: 4, yardage: 370, handicapIndex: 10),
      HoleModel(number: 15, par: 4, yardage: 396, handicapIndex: 8),
      HoleModel(number: 16, par: 3, yardage: 161, handicapIndex: 18),
      HoleModel(number: 17, par: 4, yardage: 326, handicapIndex: 16),
      HoleModel(number: 18, par: 4, yardage: 404, handicapIndex: 2),
    ],
  );

  // ── The Wolverine — Grand Traverse Resort, Acme, MI ─────────────────────
  // Blue tees | Par 72 | 6,498 yds | Rating 71.9 | Slope 140
  static final _wolverine = CourseModel(
    id: 'course-5',
    name: 'The Wolverine at Grand Traverse Resort',
    rating: 71.9,
    slope: 140,
    holes: [
      HoleModel(number: 1,  par: 4, yardage: 362, handicapIndex: 13),
      HoleModel(number: 2,  par: 4, yardage: 380, handicapIndex: 5),
      HoleModel(number: 3,  par: 5, yardage: 478, handicapIndex: 1),
      HoleModel(number: 4,  par: 4, yardage: 409, handicapIndex: 11),
      HoleModel(number: 5,  par: 3, yardage: 189, handicapIndex: 15),
      HoleModel(number: 6,  par: 4, yardage: 370, handicapIndex: 7),
      HoleModel(number: 7,  par: 4, yardage: 375, handicapIndex: 9),
      HoleModel(number: 8,  par: 5, yardage: 490, handicapIndex: 3),
      HoleModel(number: 9,  par: 3, yardage: 163, handicapIndex: 17),
      HoleModel(number: 10, par: 4, yardage: 392, handicapIndex: 4),
      HoleModel(number: 11, par: 5, yardage: 506, handicapIndex: 10),
      HoleModel(number: 12, par: 3, yardage: 185, handicapIndex: 18),
      HoleModel(number: 13, par: 4, yardage: 364, handicapIndex: 8),
      HoleModel(number: 14, par: 3, yardage: 163, handicapIndex: 16),
      HoleModel(number: 15, par: 4, yardage: 345, handicapIndex: 14),
      HoleModel(number: 16, par: 4, yardage: 439, handicapIndex: 2),
      HoleModel(number: 17, par: 4, yardage: 357, handicapIndex: 12),
      HoleModel(number: 18, par: 5, yardage: 531, handicapIndex: 6),
    ],
  );
}
