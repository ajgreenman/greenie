import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/user_model.dart';

void main() {
  group('UserModel', () {
    test('stores all fields', () {
      const user = UserModel(
        id: 'u1',
        name: 'Test User',
        email: 'test@test.com',
        isAdmin: true,
      );
      expect(user.id, 'u1');
      expect(user.name, 'Test User');
      expect(user.email, 'test@test.com');
      expect(user.isAdmin, true);
    });

    test('isAdmin can be false', () {
      const user = UserModel(
        id: 'u2',
        name: 'Regular',
        email: 'r@test.com',
        isAdmin: false,
      );
      expect(user.isAdmin, false);
    });
  });
}
