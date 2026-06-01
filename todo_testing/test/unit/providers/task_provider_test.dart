import 'package:flutter_test/flutter_test.dart';
import 'package:todo_testing/models/task.dart';
import 'package:todo_testing/providers/task_provider.dart';

void main() {
  group('TaskProvider State Management Logic', () {
    late TaskProvider provider;

    setUp(() {
      provider = TaskProvider();
    });

    test('addTask should append tasks to provider state', () {
      final task = Task(id: '1', title: 'Task 1', createdAt: DateTime.now());
      provider.addTask(task);
      expect(provider.tasks.length, 1);
    });

    test('removeTask should accurately purge item by ID', () {
      final task = Task(id: '1', title: 'Task 1', createdAt: DateTime.now());
      provider.addTask(task);
      provider.removeTask('1');
      expect(provider.tasks, isEmpty);
    });

    test('toggleTask reverses isCompleted flag safely', () {
      final task = Task(id: '1', title: 'Task 1', isCompleted: false, createdAt: DateTime.now());
      provider.addTask(task);
      provider.toggleTask('1');
      expect(provider.tasks.first.isCompleted, isTrue);
    });

    test('setFilter should cleanly split active and completed sets', () {
      provider.addTask(Task(id: '1', title: 'A', isCompleted: false, createdAt: DateTime.now()));
      provider.addTask(Task(id: '2', title: 'B', isCompleted: true, createdAt: DateTime.now()));

      provider.setFilter(TaskFilter.active);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '1');

      provider.setFilter(TaskFilter.completed);
      expect(provider.tasks.length, 1);
      expect(provider.tasks.first.id, '2');
    });
  });
}