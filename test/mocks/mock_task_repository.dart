import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/entities/task_statistics_entity.dart';
import 'package:task_manager/domain/repositories/task_repository.dart';
import 'package:task_manager/core/utils/result.dart';
import 'package:task_manager/core/errors/failures.dart';
import 'mock_data_factory.dart';

/// Enhanced Mock implementation of TaskRepository for testing
class MockTaskRepository implements TaskRepository {
  final List<TaskEntity> _tasks = [];
  bool _shouldFailOnNextOperation = false;
  Failure? _nextFailure;

  // Test control methods
  void setShouldFail(bool shouldFail, [Failure? failure]) {
    _shouldFailOnNextOperation = shouldFail;
    _nextFailure = failure ?? const UnexpectedFailure('Mock failure');
  }

  void addMockTask(TaskEntity task) {
    _tasks.add(task);
  }

  void addMockTasks(List<TaskEntity> tasks) {
    _tasks.addAll(tasks);
  }

  void clearMockTasks() {
    _tasks.clear();
  }

  Result<T>? _checkForFailure<T>() {
    if (_shouldFailOnNextOperation) {
      _shouldFailOnNextOperation = false; // Reset after use
      return Result.failure(_nextFailure ?? const UnexpectedFailure('Mock failure'));
    }
    return null; // No failure, continue with normal operation
  }

  @override
  Future<Result<List<TaskEntity>>> getAllTasks() async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(List.from(_tasks));
  }
  
  @override
  Future<Result<String>> createTask(TaskEntity task) async {
    final failureCheck = _checkForFailure<String>();
    if (failureCheck != null) return failureCheck;
    
    _tasks.add(task);
    return Result.success(task.id);
  }
  
  @override
  Future<Result<void>> updateTask(TaskEntity task) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      return const Result.success(null);
    }
    return const Result.failure(NotFoundFailure('Task not found'));
  }
  
  @override
  Future<Result<void>> deleteTask(String taskId) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    final initialLength = _tasks.length;
    _tasks.removeWhere((task) => task.id == taskId);
    if (_tasks.length < initialLength) {
      return const Result.success(null);
    }
    return const Result.failure(NotFoundFailure('Task not found'));
  }
  
  @override
  Future<Result<TaskEntity?>> getTaskById(String taskId) async {
    final failureCheck = _checkForFailure<TaskEntity?>();
    if (failureCheck != null) return failureCheck;
    
    try {
      final task = _tasks.firstWhere((task) => task.id == taskId);
      return Result.success(task);
    } catch (e) {
      return const Result.success(null);
    }
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByStatus(bool isCompleted) async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final filteredTasks = _tasks.where((task) => task.isCompleted == isCompleted).toList();
    return Result.success(filteredTasks);
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByDateRange(DateTime startDate, DateTime endDate) async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final filteredTasks = _tasks.where((task) {
      return task.deadline.isAfter(startDate.subtract(const Duration(days: 1))) &&
             task.deadline.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    return Result.success(filteredTasks);
  }
  
  @override
  Future<Result<void>> markTaskAsCompleted(String taskId) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].markAsCompleted();
      return const Result.success(null);
    }
    return const Result.failure(NotFoundFailure('Task not found'));
  }
  
  @override
  Future<Result<void>> markTaskAsIncomplete(String taskId) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    final index = _tasks.indexWhere((task) => task.id == taskId);
    if (index != -1) {
      _tasks[index] = _tasks[index].markAsIncomplete();
      return const Result.success(null);
    }
    return const Result.failure(NotFoundFailure('Task not found'));
  }
  
  @override
  Future<Result<List<TaskEntity>>> searchTasks(String query) async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final filteredTasks = _tasks.where((task) {
      return task.title.toLowerCase().contains(query.toLowerCase()) ||
             (task.description?.toLowerCase().contains(query.toLowerCase()) ?? false);
    }).toList();
    return Result.success(filteredTasks);
  }
  
  @override
  Future<Result<List<TaskEntity>>> getOverdueTasks() async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final overdueTasks = _tasks.where((task) => task.isOverdue).toList();
    return Result.success(overdueTasks);
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksDueToday() async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final todayTasks = _tasks.where((task) => task.isDueToday && !task.isCompleted).toList();
    return Result.success(todayTasks);
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksDueTomorrow() async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final tomorrowTasks = _tasks.where((task) => task.isDueTomorrow && !task.isCompleted).toList();
    return Result.success(tomorrowTasks);
  }
  
  @override
  Future<Result<List<TaskEntity>>> getTasksByPriority(TaskPriority priority) async {
    final failureCheck = _checkForFailure<List<TaskEntity>>();
    if (failureCheck != null) return failureCheck;
    
    final priorityTasks = _tasks.where((task) => task.priority == priority).toList();
    return Result.success(priorityTasks);
  }
  
  @override
  Future<Result<TaskStatisticsEntity>> getTaskStatistics() async {
    final failureCheck = _checkForFailure<TaskStatisticsEntity>();
    if (failureCheck != null) return failureCheck;
    
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));
    final monthAgo = today.subtract(const Duration(days: 30));
    
    final completedTasks = _tasks.where((task) => task.isCompleted).toList();
    final completedToday = completedTasks.where((task) => 
        task.updatedAt.isAfter(today)).length;
    final completedThisWeek = completedTasks.where((task) => 
        task.updatedAt.isAfter(weekAgo)).length;
    final completedThisMonth = completedTasks.where((task) => 
        task.updatedAt.isAfter(monthAgo)).length;
    
    final overdueTasks = _tasks.where((task) => task.isOverdue).length;
    final pendingTasks = _tasks.where((task) => !task.isCompleted).length;
    
    final completionRate = _tasks.isNotEmpty ? 
        (completedTasks.length / _tasks.length) * 100 : 0.0;
    
    // Mock completed tasks by day
    final completedTasksByDay = <int, int>{
      for (int i = 1; i <= 7; i++) i: completedTasks.length ~/ 7
    };
    
    return Result.success(TaskStatisticsEntity(
      completedTasksToday: completedToday,
      completedTasksThisWeek: completedThisWeek,
      completedTasksThisMonth: completedThisMonth,
      totalTasks: _tasks.length,
      completedTasks: completedTasks.length,
      pendingTasks: pendingTasks,
      overdueTasks: overdueTasks,
      completedTasksByDay: completedTasksByDay,
      completionRate: completionRate,
      mostProductiveDayOfWeek: 5, // Friday
    ));
  }
  
  @override
  Future<Result<List<ProductivityTrend>>> getProductivityTrend(DateTime startDate, DateTime endDate) async {
    final failureCheck = _checkForFailure<List<ProductivityTrend>>();
    if (failureCheck != null) return failureCheck;
    
    return Result.success(MockDataFactory.createMockProductivityTrend(
      days: endDate.difference(startDate).inDays
    ));
  }
  
  @override
  Future<Result<void>> deleteCompletedTasks() async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    _tasks.removeWhere((task) => task.isCompleted);
    return const Result.success(null);
  }
  
  @override
  Future<Result<void>> bulkUpdateTasks(List<TaskEntity> tasks) async {
    final failureCheck = _checkForFailure<void>();
    if (failureCheck != null) return failureCheck;
    
    for (final task in tasks) {
      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = task;
      }
    }
    return const Result.success(null);
  }
}
