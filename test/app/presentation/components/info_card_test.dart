import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/app/presentation/components/info_card.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(theme: buildLightTheme(), home: child),
  );
}

void main() {
  group('InfoCard', () {
    testWidgets('renders child', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const InfoCard(child: Text('Hello'))),
      );
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('is tappable when onTap is provided', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        _buildTestApp(
          InfoCard(child: const Text('Tap me'), onTap: () => tapped = true),
        ),
      );
      await tester.tap(find.text('Tap me'));
      expect(tapped, true);
    });

    testWidgets('renders as Card', (tester) async {
      await tester.pumpWidget(
        _buildTestApp(const InfoCard(child: Text('Card'))),
      );
      expect(find.byType(Card), findsOneWidget);
    });
  });
}
