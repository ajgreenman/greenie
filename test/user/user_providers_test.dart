import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/user_providers.dart';

void main() {
  group('User Providers', () {
    test('currentUserProvider returns a user', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final user = await container.read(currentUserProvider.future);
      expect(user.name, isNotEmpty);
      expect(user.isAdmin, isTrue);
    });

    test('fetchMembersProvider returns members for league', () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final members = await container.read(
        fetchMembersProvider('league-1').future,
      );
      expect(members, isNotEmpty);
    });
  });
}
