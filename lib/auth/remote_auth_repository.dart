import 'package:greenie/auth/auth_repository.dart';
import 'package:greenie/auth/auth_user.dart';
import 'package:greenie/data/supabase/supabase_service.dart';

/// Production auth implementation. Delegates to the remote data service.
class RemoteAuthRepository implements AuthRepository {
  const RemoteAuthRepository(this._service);

  final SupabaseService _service;

  @override
  AuthUser? get currentUser => _service.currentUser;

  @override
  Stream<AuthUser?> get authStateChanges => _service.authStateChanges;

  @override
  Future<void> signInWithMagicLink(String email) =>
      _service.signInWithMagicLink(email);

  @override
  Future<void> signOut() => _service.signOut();
}
