import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/app/presentation/components/empty_state.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: GreenieTheme.light, home: child),
  );
}

void main() {
  group('EmptyState', () {
    testWidgets('displays icon and message', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(
          const EmptyState(icon: Icons.info, message: 'Nothing here'),
        ),
      );
      expect(find.byIcon(Icons.info), findsOneWidget);
      expect(find.text('Nothing here'), findsOneWidget);
    });
  });
}
