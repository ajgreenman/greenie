import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/user_model.dart';

void main() {
  group('UserModel', () {
    test('stores all fields', () {
      const user = UserModel(
        id: 'u1',
        name: 'Test User',
        email: 'test@test.com',
        handicap: 10,
      );
      expect(user.id, 'u1');
      expect(user.name, 'Test User');
      expect(user.email, 'test@test.com');
      expect(user.handicap, 10);
    });
  });
}
