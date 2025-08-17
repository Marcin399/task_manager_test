// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TaskModelImpl _$$TaskModelImplFromJson(Map<String, dynamic> json) =>
    _$TaskModelImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      deadline: (json['deadline'] as num).toInt(),
      isCompleted: json['isCompleted'] as bool? ?? false,
      createdAt: (json['createdAt'] as num).toInt(),
      updatedAt: (json['updatedAt'] as num).toInt(),
      reminderMinutes: (json['reminderMinutes'] as num?)?.toInt(),
      priority: (json['priority'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$TaskModelImplToJson(_$TaskModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'deadline': instance.deadline,
      'isCompleted': instance.isCompleted,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'reminderMinutes': instance.reminderMinutes,
      'priority': instance.priority,
    };
