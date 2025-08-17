import 'package:task_manager/domain/entities/task_entity.dart';
import 'package:task_manager/domain/entities/task_statistics_entity.dart';

/// Factory class for creating mock data for tests
class MockDataFactory {
  /// Creates a single mock task with customizable parameters
  static TaskEntity createMockTask({
    String? id,
    String? title,
    String? description,
    DateTime? deadline,
    bool isCompleted = false,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? reminderMinutes,
    TaskPriority priority = TaskPriority.medium,
  }) {
    final now = DateTime.now();
    return TaskEntity(
      id: id ?? 'test-task-${now.millisecondsSinceEpoch}',
      title: title ?? 'Test Task',
      description: description,
      deadline: deadline ?? now.add(const Duration(days: 1)),
      isCompleted: isCompleted,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
      reminderMinutes: reminderMinutes,
      priority: priority,
    );
  }

  /// Creates multiple mock tasks with varied properties
  static List<TaskEntity> createMockTasks({int count = 5}) {
    final now = DateTime.now();
    return List.generate(count, (index) {
      return TaskEntity(
        id: 'test-task-$index',
        title: 'Test Task ${index + 1}',
        description: 'Description for task ${index + 1}',
        deadline: now.add(Duration(days: index + 1)),
        isCompleted: index % 2 == 0, // Alternate completed/pending
        createdAt: now.subtract(Duration(days: index)),
        updatedAt: now.subtract(Duration(days: index)),
        reminderMinutes: index % 3 == 0 ? 60 : null, // Some tasks have reminders
        priority: TaskPriority.values[index % TaskPriority.values.length],
      );
    });
  }

  /// Creates mock task statistics
  static TaskStatisticsEntity createMockStatistics({
    int? completedTasksToday,
    int? completedTasksThisWeek,
    int? completedTasksThisMonth,
    int? totalTasks,
    int? completedTasks,
    int? pendingTasks,
    int? overdueTasks,
  }) {
    return TaskStatisticsEntity(
      completedTasksToday: completedTasksToday ?? 3,
      completedTasksThisWeek: completedTasksThisWeek ?? 12,
      completedTasksThisMonth: completedTasksThisMonth ?? 45,
      totalTasks: totalTasks ?? 50,
      completedTasks: completedTasks ?? 30,
      pendingTasks: pendingTasks ?? 15,
      overdueTasks: overdueTasks ?? 5,
      completedTasksByDay: {
        1: 5, 2: 8, 3: 6, 4: 7, 5: 9, 6: 4, 7: 3
      },
      completionRate: 0.6,
      mostProductiveDayOfWeek: 5, // Friday
    );
  }

  /// Creates mock productivity trend data
  static List<ProductivityTrend> createMockProductivityTrend({int days = 7}) {
    final now = DateTime.now();
    return List.generate(days, (index) {
      final date = now.subtract(Duration(days: days - index - 1));
      return ProductivityTrend(
        date: date,
        completedTasks: 2 + (index % 5),
        totalTasks: 5 + (index % 3),
      );
    });
  }
}
