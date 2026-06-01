import 'package:flutter_test/flutter_test.dart';
import 'package:todo_testing/utils/validators.dart';

void main() {
  group('Validators Testing', () {
    test('validateTitle should throw error text on empty string', () {
      expect(Validators.validateTitle(''), 'Title cannot be empty');
      expect(Validators.validateTitle(null), 'Title cannot be empty');
    });

    test('validateTitle should fail on text below 3 characters', () {
      expect(Validators.validateTitle('ab'), 'Title must be at least 3 characters');
    });

    test('validateEmail should recognize valid/invalid formats', () {
      expect(Validators.validateEmail('invalid-email'), 'Invalid email format');
      expect(Validators.validateEmail('test@domain.com'), isNull);
    });

    test('isTaskOverdue returns true for past dates', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      expect(Validators.isTaskOverdue(pastDate), isTrue);
    });
  });
}