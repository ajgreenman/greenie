import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/theme/theme.dart';
import 'package:greenie/league/presentation/components/members_preview.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

const _members = [
  MemberModel(id: 'member-1', name: 'Alice', handicap: 5),
  MemberModel(id: 'member-2', name: 'Bob', handicap: 12),
  MemberModel(id: 'member-3', name: 'Carol', handicap: 2),
  MemberModel(id: 'member-4', name: 'Dave', handicap: 18),
  MemberModel(id: 'member-5', name: 'Eve', handicap: 8),
];

Widget _buildWidget({required String userMemberId}) {
  return MaterialApp(
    theme: GreenieTheme.light,
    home: Scaffold(
      body: MembersPreview(
        members: _members,
        userMemberId: userMemberId,
        leagueId: 'league-1',
      ),
    ),
  );
}

void main() {
  group('MembersPreview', () {
    testWidgets('shows column headers', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-1'));
      expect(find.text('#'), findsOneWidget);
      expect(find.text('Player'), findsOneWidget);
      expect(find.text('Hdcp'), findsOneWidget);
    });

    testWidgets('shows All Members link', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-1'));
      expect(find.text('All Members'), findsOneWidget);
    });

    // Sorted by handicap ASC: Carol(2), Alice(5), Eve(8), Bob(12), Dave(18)
    // Alice is rank 2. User=Alice → show ranks 1,2,3 → Carol, Alice, Eve.
    testWidgets('user in middle — shows surrounding members', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-1')); // Alice, hdcp 5, rank 2
      expect(find.text('Carol'), findsOneWidget);  // rank 1
      expect(find.text('Alice'), findsOneWidget);  // rank 2 (user)
      expect(find.text('Eve'), findsOneWidget);    // rank 3
      expect(find.text('Bob'), findsNothing);
      expect(find.text('Dave'), findsNothing);
    });

    testWidgets('user in first — shows top 3', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-3')); // Carol, rank 1
      expect(find.text('Carol'), findsOneWidget);  // rank 1 (user)
      expect(find.text('Alice'), findsOneWidget);  // rank 2
      expect(find.text('Eve'), findsOneWidget);    // rank 3
      expect(find.text('Bob'), findsNothing);
    });

    testWidgets('user in last — shows bottom 3', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-4')); // Dave, rank 5
      expect(find.text('Eve'), findsOneWidget);    // rank 3
      expect(find.text('Bob'), findsOneWidget);    // rank 4
      expect(find.text('Dave'), findsOneWidget);   // rank 5 (user)
      expect(find.text('Carol'), findsNothing);
    });

    testWidgets('shows handicap values', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-3')); // top 3: Carol(2), Alice(5), Eve(8)
      expect(find.text('2'), findsOneWidget);
      expect(find.text('5'), findsOneWidget);
      expect(find.text('8'), findsOneWidget);
    });

    testWidgets('shows rank numbers', (tester) async {
      await tester.pumpWidget(_buildWidget(userMemberId: 'member-3'));
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('#2'), findsOneWidget);
      expect(find.text('#3'), findsOneWidget);
    });

    testWidgets('sorts ties in handicap alphabetically', (tester) async {
      const tied = [
        MemberModel(id: 'm-a', name: 'Zara', handicap: 10),
        MemberModel(id: 'm-b', name: 'Anna', handicap: 10),
      ];
      await tester.pumpWidget(
        MaterialApp(
          theme: GreenieTheme.light,
          home: const Scaffold(
            body: MembersPreview(
              members: tied,
              userMemberId: 'm-a',
              leagueId: 'league-1',
            ),
          ),
        ),
      );
      // Anna sorts before Zara alphabetically → Anna is rank 1
      expect(find.text('#1'), findsOneWidget);
      expect(find.text('Anna'), findsOneWidget);
    });
  });
}
