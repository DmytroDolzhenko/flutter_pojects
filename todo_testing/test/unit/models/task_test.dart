import 'package:flutter_test/flutter_test.dart';
import 'package:todo_testing/models/task.dart';

void main() {
  group('Task Model Group', () {
    test('Should correctly instantiate Task model', () {
      final task = Task(id: '1', title: 'Test', createdAt: DateTime(2026, 1, 1));
      expect(task.id, '1');
      expect(task.title, 'Test');
      expect(task.isCompleted, false);
    });

    test('fromJson should return valid model', () {
      final Map<String, dynamic> json = {
        'id': '123',
        'title': 'Test JSON',
        'isCompleted': true,
        'createdAt': '2026-06-01T12:00:00.000',
      };
      final task = Task.fromJson(json);
      expect(task.id, '123');
      expect(task.isCompleted, true);
    });

    test('toJson should output correct map representation', () {
      final task = Task(id: '2', title: 'To Json', isCompleted: true, createdAt: DateTime(2026, 6, 1));
      final json = task.toJson();
      expect(json['id'], '2');
      expect(json['isCompleted'], true);
    });

    test('copyWith should respect overrides and keep immutability', () {
      final task = Task(id: '1', title: 'Old', createdAt: DateTime.now());
      final updated = task.copyWith(title: 'New', isCompleted: true);
      expect(updated.title, 'New');
      expect(updated.id, '1');
      expect(updated.isCompleted, true);
    });
  });
}