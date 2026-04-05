import 'package:greenie/auth/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_providers.g.dart';

@Riverpod(keepAlive: true)
AuthRepository authRepository(Ref ref) {
  throw UnimplementedError(
    'authRepositoryProvider must be overridden via ProviderScope. '
    'Launch the app via main.dart or main_development.dart.',
  );
}
