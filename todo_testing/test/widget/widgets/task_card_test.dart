import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo_testing/models/task.dart';
import 'package:todo_testing/widgets/task_card.dart';

void main() {
  group('TaskCard Widget Tests', () {
    final testTask = Task(id: '1', title: 'Task Card Render', createdAt: DateTime.now());

    testWidgets('Should print title text on card widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskCard(task: testTask, onToggle: () {}, onDelete: () {})),
      ));
      expect(find.text('Task Card Render'), findsOneWidget);
    });

    testWidgets('Tapping checkbox should invoke onToggle closure safely', (WidgetTester tester) async {
      bool toggleInvoked = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskCard(task: testTask, onToggle: () => toggleInvoked = true, onDelete: () {})),
      ));

      await tester.tap(find.byType(Checkbox));
      expect(toggleInvoked, isTrue);
    });

    testWidgets('Tapping delete button executes onDelete function context', (WidgetTester tester) async {
      bool deleteInvoked = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(body: TaskCard(task: testTask, onToggle: () {}, onDelete: () => deleteInvoked = true)),
      ));

      await tester.tap(find.byIcon(Icons.delete));
      expect(deleteInvoked, isTrue);
    });
  });
}