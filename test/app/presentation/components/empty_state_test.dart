import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/app/presentation/components/empty_state.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('EmptyState', () {
    testWidgets('displays icon and message', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const EmptyState(icon: Icons.sports_golf, message: 'Nothing here'),
        ),
      );
      expect(find.byIcon(Icons.sports_golf), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
}
