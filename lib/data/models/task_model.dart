import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/task_entity.dart';

part 'task_model.freezed.dart';
part 'task_model.g.dart';

@freezed
class TaskModel with _$TaskModel {
  const factory TaskModel({
    required String id,
    required String title,
    String? description,
    required int deadline, 
    @Default(false) bool isCompleted,
    required int createdAt, 
    required int updatedAt,
    int? reminderMinutes,
    @Default(1) int priority, 
  }) = _TaskModel;
  
  const TaskModel._();
  
  factory TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);
  
  factory TaskModel.fromDatabase(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      deadline: map['deadline'] as int,
      isCompleted: (map['isCompleted'] as int) == 1,
      createdAt: map['createdAt'] as int,
      updatedAt: map['updatedAt'] as int,
      reminderMinutes: map['reminderMinutes'] as int?,
      priority: map['priority'] as int? ?? 1,
    );
  }
  
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'deadline': deadline,
      'isCompleted': isCompleted ? 1 : 0,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'reminderMinutes': reminderMinutes,
      'priority': priority,
    };
  }
  
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      deadline: DateTime.fromMillisecondsSinceEpoch(deadline),
      isCompleted: isCompleted,
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
      reminderMinutes: reminderMinutes,
      priority: TaskPriority.fromValue(priority),
    );
  }
  
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      deadline: entity.deadline.millisecondsSinceEpoch,
      isCompleted: entity.isCompleted,
      createdAt: entity.createdAt.millisecondsSinceEpoch,
      updatedAt: entity.updatedAt.millisecondsSinceEpoch,
      reminderMinutes: entity.reminderMinutes,
      priority: entity.priority.value,
    );
  }
}
