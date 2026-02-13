import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/course/presentation/components/hole_header_cell.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('HoleHeaderCell', () {
    testWidgets('displays hole number', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const HoleHeaderCell(holeNumber: 7)),
      );
      expect(find.text('7'), findsOneWidget);
    });
  });
}
