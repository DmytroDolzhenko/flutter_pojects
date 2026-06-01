import 'package:flutter/foundation.dart';
import '../models/task.dart';

enum TaskFilter { all, active, completed }

class TaskProvider extends ChangeNotifier {
  List<Task> _tasks = [];
  TaskFilter _filter = TaskFilter.all;

  List<Task> get tasks => _getFilteredTasks();
  List<Task> get allTasksRaw => _tasks;
  TaskFilter get filter => _filter;

  void setTasks(List<Task> newTasks) {
    _tasks = List.from(newTasks);
    notifyListeners();
  }

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(isCompleted: !_tasks[index].isCompleted);
      notifyListeners();
    }
  }

  void setFilter(TaskFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  List<Task> _getFilteredTasks() {
    switch (_filter) {
      case TaskFilter.active:
        return _tasks.where((task) => !task.isCompleted).toList();
      case TaskFilter.completed:
        return _tasks.where((task) => task.isCompleted).toList();
      case TaskFilter.all:
        return _tasks;
    }
  }
}