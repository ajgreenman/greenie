import 'package:greenie/user/infrastructure/models/member_model.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';
import 'package:greenie/user/user_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_providers.g.dart';

@riverpod
Future<UserModel> currentUser(Ref ref) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.getCurrentUser();
}

@riverpod
Future<List<MemberModel>> fetchMembers(Ref ref, String leagueId) async {
  final repository = ref.watch(userRepositoryProvider);
  return repository.fetchMembersForLeague(leagueId);
}
