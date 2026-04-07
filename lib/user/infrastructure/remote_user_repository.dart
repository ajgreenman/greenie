import 'package:greenie/data/supabase/supabase_service.dart';
import 'package:greenie/user/infrastructure/models/models.dart';
import 'package:greenie/user/infrastructure/user_repository.dart';
import 'package:greenie/user/user_model.dart';

class RemoteUserRepository extends UserRepository {
  RemoteUserRepository(this._service);

  final SupabaseService _service;

  @override
  Future<UserModel> getCurrentUser() async {
    final row = await _service.fetchCurrentProfile();
    return UserModel(
      id: row['id'] as String,
      name: row['name'] as String,
      email: row['email'] as String,
      handicap: row['handicap'] as int,
    );
  }

  @override
  Future<List<MemberModel>> fetchMembersForLeague(String leagueId) async {
    final rows = await _service.fetchLeagueMembers(leagueId);
    return rows.map((row) {
      final profile = row['profiles'] as Map<String, dynamic>;
      final handicap =
          (row['handicap_override'] as int?) ?? (profile['handicap'] as int);
      return MemberModel(
        id: profile['id'] as String,
        name: profile['name'] as String,
        handicap: handicap,
      );
    }).toList();
  }
}
