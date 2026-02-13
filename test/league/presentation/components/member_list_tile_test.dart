import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme.dart';
import 'package:greenie/league/presentation/components/member_list_tile.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

Widget _buildTestApp(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      theme: buildLightTheme(),
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  group('MemberListTile', () {
    testWidgets('displays name and handicap', (tester) async {
      const member = MemberModel(id: 'm1', name: 'Alice Smith', handicap: 10);
      await tester.pumpWidget(
        _buildTestApp(const MemberListTile(member: member)),
      );
      expect(find.text('Alice Smith'), findsOneWidget);
      expect(find.text('HC 10'), findsOneWidget);
    });

    testWidgets('shows initials in CircleAvatar', (tester) async {
      const member = MemberModel(id: 'm1', name: 'Alice Smith', handicap: 10);
      await tester.pumpWidget(
        _buildTestApp(const MemberListTile(member: member)),
      );
      expect(find.byType(CircleAvatar), findsOneWidget);
      expect(find.text('AS'), findsOneWidget);
    });
  });
}
