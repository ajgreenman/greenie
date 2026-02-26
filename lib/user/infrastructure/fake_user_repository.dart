import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';
import 'package:greenie/user/user_model.dart';

class FakeUserRepository extends UserRepository {
  @override
  Future<UserModel> getCurrentUser() async {
    return const UserModel(
      id: 'user-1',
      name: 'AJ Greenman',
      email: 'aj@greenie.app',
      isAdmin: true,
      memberId: 'member-1',
    );
  }

  @override
  Future<List<MemberModel>> fetchMembersForLeague(String leagueId) async {
    return members;
  }

  static const members = [
    MemberModel(id: 'member-1', name: 'AJ Greenman', handicap: 10),
    MemberModel(id: 'member-2', name: 'Brandon Ayers', handicap: 9),
    MemberModel(id: 'member-3', name: 'Dirty Mike', handicap: 8),
    MemberModel(id: 'member-4', name: 'Aaron Greenman', handicap: 3),
    MemberModel(id: 'member-5', name: 'Adam Boelkins', handicap: 10),
    MemberModel(id: 'member-6', name: 'Brady Greenman', handicap: 2),
    MemberModel(id: 'member-7', name: 'Ryan Confer', handicap: 5),
    MemberModel(id: 'member-8', name: 'Brett Knaus', handicap: 15),
    MemberModel(id: 'member-9', name: 'Ryan Ayers', handicap: 12),
    MemberModel(id: 'member-10', name: 'Matt Ayers', handicap: 12),
    MemberModel(id: 'member-11', name: 'Andrew Dunscombe', handicap: 6),
    MemberModel(id: 'member-12', name: 'Jake Steggles', handicap: 11),
    MemberModel(id: 'member-13', name: 'Joel Bremer', handicap: 17),
    MemberModel(id: 'member-14', name: 'Ben Casciano', handicap: 1),
  ];
}
