import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task.dart';

class TaskApiService {
  final http.Client client;

  TaskApiService({required this.client});

  Future<List<Task>> fetchTasks() async {
    final response = await client.get(
      Uri.parse('https://api.example.com/tasks')
      );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Task.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> createTask(String title) async {
    final response = await client.post(
      Uri.parse('https://api.example.com/tasks'),
      body: jsonEncode({'title': title}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return Task.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create task');
    }
  }
}