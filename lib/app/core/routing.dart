import 'package:go_router/go_router.dart';
import 'package:greenie/app/presentation/home_screen.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'routing.g.dart';

@riverpod
GoRouter router(Ref ref) {
  return GoRouter(
    routes: [GoRoute(path: '/', builder: (context, state) => HomeScreen())],
  );
}
