import 'package:flutter_test/flutter_test.dart';
import 'package:greenie/app/core/extensions/date_extensions.dart';

void main() {
  group('DateExtensions', () {
    test('displayDate formats correctly', () {
      final date = DateTime(2025, 1, 15);
      expect(date.displayDate, 'Jan 15, 2025');
    });

    test('displayDate for December', () {
      final date = DateTime(2025, 12, 25);
      expect(date.displayDate, 'Dec 25, 2025');
    });
  });
}
