import 'package:greenie/auth/auth_exception.dart';
import 'package:greenie/auth/auth_user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

part 'supabase_service.g.dart';

@Riverpod(keepAlive: true)
SupabaseService supabaseService(Ref ref) => SupabaseService();

/// The single point of contact with Supabase.
/// This is the ONLY file in the app that imports supabase_flutter.
/// All remote repositories delegate to this class — no other file
/// should reference supabase_flutter directly.
class SupabaseService {
  sb.SupabaseClient get _client => sb.Supabase.instance.client;

  /// Initializes the remote backend. Call once in [main] before [bootstrap].
  /// Reads credentials from --dart-define-from-file=dart_defines/production.json.
  static Future<void> initialize() async {
    const url = String.fromEnvironment('SUPABASE_URL');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    assert(
      url.isNotEmpty && anonKey.isNotEmpty,
      'Missing backend credentials. Run with --dart-define-from-file=dart_defines/production.json',
    );
    await sb.Supabase.initialize(
      url: url,
      anonKey: anonKey,
      authOptions: const sb.FlutterAuthClientOptions(
        authFlowType: sb.AuthFlowType.pkce,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUser(id: user.id, email: user.email ?? '');
  }

  Stream<AuthUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return AuthUser(id: user.id, email: user.email ?? '');
    });
  }

  Future<void> signInWithMagicLink(String email) async {
    try {
      await _client.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'io.greenie://login-callback',
      );
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on sb.AuthException catch (e) {
      throw AuthException(e.message);
    }
  }

  // ---------------------------------------------------------------------------
  // User / profiles
  // ---------------------------------------------------------------------------

  /// Returns the profile row for the currently signed-in user.
  Future<Map<String, dynamic>> fetchCurrentProfile() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw StateError('No authenticated user');
    final data = await _client
        .from('profiles')
        .select('id, name, email, handicap')
        .eq('id', userId)
        .single();
    return data;
  }

  /// Returns all members of a league, with effective handicap
  /// (handicap_override when set, otherwise the profile's global handicap).
  Future<List<Map<String, dynamic>>> fetchLeagueMembers(
    String leagueId,
  ) async {
    final data = await _client
        .from('league_members')
        .select('handicap_override, profiles(id, name, handicap)')
        .eq('league_id', leagueId);
    return List<Map<String, dynamic>>.from(data);
  }
}
