import 'package:greenie/auth/auth_user.dart';

abstract class AuthRepository {
  /// The currently signed-in user, or null if unauthenticated.
  AuthUser? get currentUser;

  /// Emits the current user whenever auth state changes.
  /// Emits null when signed out.
  Stream<AuthUser?> get authStateChanges;

  /// Sends a magic link to [email].
  /// Throws [AuthException] on failure.
  Future<void> signInWithMagicLink(String email);

  /// Signs the current user out.
  Future<void> signOut();
}
