import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:todo_testing/services/task_api_service.dart';

@GenerateMocks([http.Client])
import 'task_api_service_test.mocks.dart';

void main() {
  group('TaskApiService Mock Testing', () {
    late TaskApiService apiService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      apiService = TaskApiService(client: mockClient);
    });

    test('fetchTasks returns items correctly on 200 HTTP response', () async {
      final mockJsonString = jsonEncode([
        {
          'id': '1',
          'title': 'Mock Task',
          'isCompleted': false,
          'createdAt': '2026-06-01T12:00:00.000'
        }
      ]);

      when(mockClient.get(any)).thenAnswer((_) async => http.Response(mockJsonString, 200));

      final result = await apiService.fetchTasks();
      expect(result.length, 1);
      expect(result.first.title, 'Mock Task');
    });

    test('fetchTasks throws exception on 404 HTTP code failure', () async {
      when(mockClient.get(any)).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => apiService.fetchTasks(), throwsException);
    });
  });
}