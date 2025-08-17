import 'dart:convert';

import '../storage/local_storage.dart';
import '../../data/models/task_model.dart';
import '../utils/logger.dart';

class WebStorageAdapter {
  static const String _tasksKey = 'tasks';
  final LocalStorage _localStorage;
  
  WebStorageAdapter(this._localStorage);
  
  Future<List<TaskModel>> getAllTasks() async {
    try {
      final tasksJson = await _localStorage.getString(_tasksKey);
      if (tasksJson == null) return [];
      
      final List<dynamic> tasksList = jsonDecode(tasksJson);
      return tasksList.map((json) => TaskModel.fromJson(json)).toList();
    } catch (e) {
      Logger.error('Błąd podczas ładowania zadań z pamięci web', error: e, tag: 'WebStorage');
      return [];
    }
  }
  
  Future<void> saveTasks(List<TaskModel> tasks) async {
    try {
      final tasksJson = jsonEncode(tasks.map((task) => task.toJson()).toList());
      await _localStorage.setString(_tasksKey, tasksJson);
    } catch (e) {
      Logger.error('Błąd podczas zapisywania zadań do pamięci web', error: e, tag: 'WebStorage');
    }
  }
  
  Future<TaskModel?> getTaskById(String id) async {
    final tasks = await getAllTasks();
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  Future<void> createTask(TaskModel task) async {
    final tasks = await getAllTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }
  
  Future<void> updateTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }
  
  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }
  
  Future<List<TaskModel>> getTasksByStatus(bool isCompleted) async {
    final tasks = await getAllTasks();
    return tasks.where((task) => task.isCompleted == isCompleted).toList();
  }
}
