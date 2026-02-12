import 'package:greenie/user/infrastructure/fake_user_repository.dart';
import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepository userRepository(Ref ref) {
  return FakeUserRepository();
}

abstract class UserRepository {
  Future<UserModel> getCurrentUser();
  Future<List<MemberModel>> fetchMembersForLeague(String leagueId);
}
