import 'package:greenie/dev/dev_scenario.dart';
import 'package:greenie/user/infrastructure/models/models.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';
import 'package:greenie/user/user_model.dart';

class FakeUserRepository extends UserRepository {
  FakeUserRepository({this.scenario = const ActiveSeason()});

  final DevScenario scenario;

  @override
  Future<UserModel> getCurrentUser() async => switch (scenario) {
    NewLeagueMember() => _brandon,
    _ => _aj,
  };

  @override
  Future<List<MemberModel>> fetchMembersForLeague(String leagueId) async =>
      switch (scenario) {
        FreshSignup() => [],
        NewLeagueAdmin() => [_memberAj],
        NewLeagueMember() || FirstRoundUpcoming() => _smallGroup,
        _ => allMembers,
      };

  // ── Users ────────────────────────────────────────────────────────────────

  static const _aj = UserModel(
    id: 'user-1',
    name: 'AJ Greenman',
    email: 'brother3@greenie.app',
    handicap: 10,
  );

  static const _brandon = UserModel(
    id: 'user-2',
    name: 'Brandon Ayers',
    email: 'brandon@greenie.app',
    handicap: 9,
  );

  // ── Members ──────────────────────────────────────────────────────────────

  static const _memberAj = MemberModel(id: 'user-1', name: 'AJ Greenman', handicap: 10);

  static const _smallGroup = [
    MemberModel(id: 'user-1', name: 'AJ Greenman',   handicap: 10),
    MemberModel(id: 'user-2', name: 'Brandon Ayers',  handicap: 9),
    MemberModel(id: 'user-4', name: 'Aaron Greenman', handicap: 3),
    MemberModel(id: 'user-6', name: 'Brady Greenman', handicap: 2),
  ];

  static const allMembers = [
    MemberModel(id: 'user-1',  name: 'AJ Greenman',      handicap: 10),
    MemberModel(id: 'user-2',  name: 'Brandon Ayers',     handicap: 9),
    MemberModel(id: 'user-3',  name: 'Dirty Mike',        handicap: 8),
    MemberModel(id: 'user-4',  name: 'Aaron Greenman',    handicap: 3),
    MemberModel(id: 'user-5',  name: 'Adam Boelkins',     handicap: 10),
    MemberModel(id: 'user-6',  name: 'Brady Greenman',    handicap: 2),
    MemberModel(id: 'user-7',  name: 'Ryan Confer',       handicap: 5),
    MemberModel(id: 'user-8',  name: 'Brett Knaus',       handicap: 15),
    MemberModel(id: 'user-9',  name: 'Ryan Ayers',        handicap: 12),
    MemberModel(id: 'user-10', name: 'Matt Ayers',        handicap: 12),
    MemberModel(id: 'user-11', name: 'Andrew Dunscombe',  handicap: 6),
    MemberModel(id: 'user-12', name: 'Jake Steggles',     handicap: 11),
    MemberModel(id: 'user-13', name: 'Joel Bremer',       handicap: 17),
    MemberModel(id: 'user-14', name: 'Ben Casciano',      handicap: 1),
  ];
}
