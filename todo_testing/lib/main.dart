import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_testing/providers/task_provider.dart';
import 'package:todo_testing/screens/home_screen.dart';
import 'package:todo_testing/screens/details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: MaterialApp(
        title: 'Todo App Testing',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        routes: {
          '/details': (context) => const DetailsScreen(),
        },
      ),
    );
  }
}