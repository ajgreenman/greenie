import 'package:greenie/course/infrastructure/models/models.dart';
import 'package:greenie/course/infrastructure/course_repository.dart';
import 'package:greenie/data/supabase/supabase_service.dart';

class RemoteCourseRepository extends CourseRepository {
  RemoteCourseRepository(this._service);

  final SupabaseService _service;

  @override
  Future<List<CourseModel>> fetchCourses() async {
    final rows = await _service.fetchCourses();
    return rows.map(_mapCourse).toList();
  }

  @override
  Future<CourseModel?> fetchCourse(String id) async {
    final row = await _service.fetchCourse(id);
    if (row == null) return null;
    return _mapCourse(row);
  }

  CourseModel _mapCourse(Map<String, dynamic> row) {
    final holeRows = row['holes'] as List<dynamic>;
    final holes = holeRows
        .map((h) => HoleModel(
              number: h['number'] as int,
              par: h['par'] as int,
              yardage: h['yardage'] as int,
              handicapIndex: h['handicap_index'] as int,
            ))
        .toList()
      ..sort((a, b) => a.number.compareTo(b.number));
    return CourseModel(
      id: row['id'] as String,
      name: row['name'] as String,
      holes: holes,
      rating: (row['rating'] as num?)?.toDouble(),
      slope: row['slope'] as int?,
    );
  }
}
