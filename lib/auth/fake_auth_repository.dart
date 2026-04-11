import 'dart:async';

import 'package:greenie/auth/auth_exception.dart';
import 'package:greenie/auth/auth_repository.dart';
import 'package:greenie/auth/auth_user.dart';

/// Fully stateful in-memory auth. Supports sign-in, sign-out, and multiple
/// fake accounts — dev behaves identically to production, just without email.
///
/// Supported accounts:
///   brother3@greenie.app — AJ Greenman    (league admin, hdcp 10)
///   brother4@greenie.app — Aaron Greenman (member, hdcp 3)
///   brother6@greenie.app — Brady Greenman (member, hdcp 2)
class FakeAuthRepository implements AuthRepository {
  static const _accounts = {
    'brother3@greenie.app': AuthUser(id: 'user-1', email: 'brother3@greenie.app'),
    'brother4@greenie.app': AuthUser(id: 'user-4', email: 'brother4@greenie.app'),
    'brother6@greenie.app': AuthUser(id: 'user-6', email: 'brother6@greenie.app'),
  };

  AuthUser? _currentUser = _accounts['brother3@greenie.app'];
  final _controller = StreamController<AuthUser?>.broadcast();

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<void> signInWithMagicLink(String email) async {
    final user = _accounts[email.toLowerCase().trim()];
    if (user == null) {
      throw AuthException(
        'No fake account for "$email". '
        'Try: ${_accounts.keys.join(', ')}',
      );
    }
    _currentUser = user;
    _controller.add(_currentUser);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }
}
