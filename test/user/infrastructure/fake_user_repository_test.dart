import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/infrastructure/fake_user_repository.dart';

void main() {
  late FakeUserRepository repo;

  setUp(() {
    repo = FakeUserRepository();
  });

  group('FakeUserRepository', () {
    test('getCurrentUser returns an admin user', () async {
      final user = await repo.getCurrentUser();
      expect(user.isAdmin, true);
      expect(user.name, isNotEmpty);
      expect(user.email, isNotEmpty);
    });

    test('fetchMembersForLeague returns members', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      expect(members.length, 6);
    });

    test('members have unique IDs', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      final ids = members.map((m) => m.id).toSet();
      expect(ids.length, members.length);
    });

    test('members have valid handicaps', () async {
      final members = await repo.fetchMembersForLeague('league-1');
      for (final member in members) {
        expect(member.handicap, greaterThanOrEqualTo(0));
      }
    });
  });
}
