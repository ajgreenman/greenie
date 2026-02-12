import 'package:flutter/material.dart';
import 'package:greenie/course/infrastructure/models/course.dart';
import 'package:greenie/course/infrastructure/models/hole.dart';

class Scorecard extends StatelessWidget {
  const Scorecard({super.key, required this.course});

  final CourseModel course;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 4,
      children: [
        Text(course.name),
        Text('Par ${course.totalPar}'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            spacing: 1,
            children: course.holes.map((hole) => _HoleColumn(hole)).toList(),
          ),
        ),
      ],
    );
  }
}

class _HoleColumn extends StatelessWidget {
  const _HoleColumn(this.hole);

  final HoleModel hole;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('${hole.number}'), Divider(), Text('${hole.par}')],
    );
  }
}
