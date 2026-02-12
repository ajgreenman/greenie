import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/round/infrastructure/models/round_status.dart';

void main() {
  group('RoundStatus', () {
    test('displayName for upcoming', () {
      expect(RoundStatus.upcoming.displayName, 'Upcoming');
    });

    test('displayName for inProgress', () {
      expect(RoundStatus.inProgress.displayName, 'In Progress');
    });

    test('displayName for completed', () {
      expect(RoundStatus.completed.displayName, 'Completed');
    });
  });
}
