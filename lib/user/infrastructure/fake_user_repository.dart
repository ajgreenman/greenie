import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';
import 'package:greenie/user/user_model.dart';

class FakeUserRepository extends UserRepository {
  @override
  Future<UserModel> getCurrentUser() async {
    return const UserModel(
      id: 'user-1',
      name: 'Alex Greenman',
      email: 'alex@greenie.app',
      isAdmin: true,
    );
  }

  @override
  Future<List<MemberModel>> fetchMembersForLeague(String leagueId) async {
    return members;
  }

  static const members = [
    MemberModel(id: 'member-1', name: 'Alex Greenman', handicap: 12),
    MemberModel(id: 'member-2', name: 'Jordan Smith', handicap: 18),
    MemberModel(id: 'member-3', name: 'Casey Williams', handicap: 8),
    MemberModel(id: 'member-4', name: 'Taylor Brown', handicap: 22),
    MemberModel(id: 'member-5', name: 'Morgan Davis', handicap: 15),
    MemberModel(id: 'member-6', name: 'Riley Johnson', handicap: 28),
  ];
}
