import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';

void main() {
  group('MemberModel', () {
    test('stores id, name, and handicap', () {
      const member = MemberModel(id: 'm1', name: 'John Doe', handicap: 15);
      expect(member.id, 'm1');
      expect(member.name, 'John Doe');
      expect(member.handicap, 15);
    });

    test('initials from two-word name', () {
      const member = MemberModel(id: 'm1', name: 'John Doe', handicap: 10);
      expect(member.initials, 'JD');
    });

    test('initials from three-word name uses first and last', () {
      const member = MemberModel(
        id: 'm1',
        name: 'John Michael Doe',
        handicap: 10,
      );
      expect(member.initials, 'JD');
    });

    test('initials from single-word name', () {
      const member = MemberModel(id: 'm1', name: 'Jo', handicap: 10);
      expect(member.initials, 'JO');
    });

    test('initials from single character name', () {
      const member = MemberModel(id: 'm1', name: 'J', handicap: 10);
      expect(member.initials, 'J');
    });
  });
}
