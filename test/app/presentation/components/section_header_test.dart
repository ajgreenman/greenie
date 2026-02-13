import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/app/presentation/components/section_header.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('SectionHeader', () {
    testWidgets('displays title', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const SectionHeader(title: 'My Section')),
      );
      expect(find.text('My Section'), findsOneWidget);
    });

    testWidgets('displays trailing widget when provided', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const SectionHeader(title: 'My Section', trailing: Icon(Icons.add)),
        ),
      );
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('no trailing widget when not provided', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const SectionHeader(title: 'My Section')),
      );
      expect(find.byIcon(Icons.add), findsNothing);
    });
  });
}
