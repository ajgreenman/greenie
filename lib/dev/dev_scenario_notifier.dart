import 'package:greenie/dev/dev_scenario.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dev_scenario_notifier.g.dart';

@Riverpod(keepAlive: true)
class DevScenarioNotifier extends _$DevScenarioNotifier {
  @override
  DevScenario build() => const ActiveSeason();

  void select(DevScenario scenario) => state = scenario;
}
