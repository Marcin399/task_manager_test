import 'package:freezed_annotation/freezed_annotation.dart';

part 'task_entity.freezed.dart';

@freezed
class TaskEntity with _$TaskEntity {
  const factory TaskEntity({
    required String id,
    required String title,
    String? description,
    required DateTime deadline,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
    required DateTime updatedAt,
    int? reminderMinutes,
    @Default(TaskPriority.medium) TaskPriority priority,
  }) = _TaskEntity;
  
  const TaskEntity._();
  
  // Business logic methods
  bool get isOverdue => 
      !isCompleted && deadline.isBefore(DateTime.now());
  
  bool get isDueToday {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(deadline.year, deadline.month, deadline.day);
    return taskDate.isAtSameDay(today);
  }
  
  bool get isDueTomorrow {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final taskDate = DateTime(deadline.year, deadline.month, deadline.day);
    return taskDate.isAtSameDay(tomorrow);
  }
  
  Duration get timeUntilDeadline => deadline.difference(DateTime.now());
  
  bool get hasReminder => reminderMinutes != null;
  
  DateTime? get reminderTime {
    if (reminderMinutes == null) return null;
    return deadline.subtract(Duration(minutes: reminderMinutes!));
  }
  
  TaskEntity markAsCompleted() {
    return copyWith(
      isCompleted: true,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity markAsIncomplete() {
    return copyWith(
      isCompleted: false,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity updateTitle(String newTitle) {
    return copyWith(
      title: newTitle,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity updateDescription(String? newDescription) {
    return copyWith(
      description: newDescription,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity updateDeadline(DateTime newDeadline) {
    return copyWith(
      deadline: newDeadline,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity updateReminder(int? reminderMinutes) {
    return copyWith(
      reminderMinutes: reminderMinutes,
      updatedAt: DateTime.now(),
    );
  }
  
  TaskEntity updatePriority(TaskPriority newPriority) {
    return copyWith(
      priority: newPriority,
      updatedAt: DateTime.now(),
    );
  }
}

enum TaskPriority {
  low(0),
  medium(1),
  high(2),
  urgent(3);
  
  const TaskPriority(this.value);
  final int value;
  
  static TaskPriority fromValue(int value) {
    return TaskPriority.values.firstWhere(
      (priority) => priority.value == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

extension DateTimeComparison on DateTime {
  bool isAtSameDay(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }
}
