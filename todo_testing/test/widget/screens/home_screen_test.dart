import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:todo_testing/providers/task_provider.dart';
import 'package:todo_testing/screens/home_screen.dart';
import 'package:todo_testing/screens/details_screen.dart';

void main() {
  group('HomeScreen Workflow Widget Tests', () {
    late TaskProvider mockProvider;

    setUp(() {
      mockProvider = TaskProvider();
    });

    Widget createTestScreen() {
      return ChangeNotifierProvider<TaskProvider>.value(
        value: mockProvider,
        child: MaterialApp(
          home: const HomeScreen(),
          routes: {
            '/details': (context) => const DetailsScreen(),
          },
        ),
      );
    }

    testWidgets('EmptyState should show text when provider list has zero tasks', (WidgetTester tester) async {
      await tester.pumpWidget(createTestScreen());
      expect(find.byKey(const Key('empty_state_text')), findsOneWidget);
    });

    testWidgets('Form validation logic prevents submission on blank text entry', (WidgetTester tester) async {
      await tester.pumpWidget(createTestScreen());
      await tester.tap(find.text('Add Task'));
      await tester.pump();

      expect(find.text('Title cannot be empty'), findsOneWidget);
    });

    testWidgets('Navigation handles moving cleanly from Home to Details view tier', (WidgetTester tester) async {
      await tester.pumpWidget(createTestScreen());
      await tester.tap(find.byIcon(Icons.info));
      await tester.pumpAndSettle();

      expect(find.descendant(of: find.byType(AppBar), matching: find.text('Details Screen')), findsOneWidget);    });
  });
}