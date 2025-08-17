// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskEntity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get deadline => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  int? get reminderMinutes => throw _privateConstructorUsedError;
  TaskPriority get priority => throw _privateConstructorUsedError;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskEntityCopyWith<TaskEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskEntityCopyWith<$Res> {
  factory $TaskEntityCopyWith(
    TaskEntity value,
    $Res Function(TaskEntity) then,
  ) = _$TaskEntityCopyWithImpl<$Res, TaskEntity>;
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    DateTime deadline,
    bool isCompleted,
    DateTime createdAt,
    DateTime updatedAt,
    int? reminderMinutes,
    TaskPriority priority,
  });
}

/// @nodoc
class _$TaskEntityCopyWithImpl<$Res, $Val extends TaskEntity>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? deadline = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? reminderMinutes = freezed,
    Object? priority = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            deadline: null == deadline
                ? _value.deadline
                : deadline // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            isCompleted: null == isCompleted
                ? _value.isCompleted
                : isCompleted // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: null == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            reminderMinutes: freezed == reminderMinutes
                ? _value.reminderMinutes
                : reminderMinutes // ignore: cast_nullable_to_non_nullable
                      as int?,
            priority: null == priority
                ? _value.priority
                : priority // ignore: cast_nullable_to_non_nullable
                      as TaskPriority,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskEntityImplCopyWith<$Res>
    implements $TaskEntityCopyWith<$Res> {
  factory _$$TaskEntityImplCopyWith(
    _$TaskEntityImpl value,
    $Res Function(_$TaskEntityImpl) then,
  ) = __$$TaskEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String title,
    String? description,
    DateTime deadline,
    bool isCompleted,
    DateTime createdAt,
    DateTime updatedAt,
    int? reminderMinutes,
    TaskPriority priority,
  });
}

/// @nodoc
class __$$TaskEntityImplCopyWithImpl<$Res>
    extends _$TaskEntityCopyWithImpl<$Res, _$TaskEntityImpl>
    implements _$$TaskEntityImplCopyWith<$Res> {
  __$$TaskEntityImplCopyWithImpl(
    _$TaskEntityImpl _value,
    $Res Function(_$TaskEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = freezed,
    Object? deadline = null,
    Object? isCompleted = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? reminderMinutes = freezed,
    Object? priority = null,
  }) {
    return _then(
      _$TaskEntityImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        deadline: null == deadline
            ? _value.deadline
            : deadline // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        isCompleted: null == isCompleted
            ? _value.isCompleted
            : isCompleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        reminderMinutes: freezed == reminderMinutes
            ? _value.reminderMinutes
            : reminderMinutes // ignore: cast_nullable_to_non_nullable
                  as int?,
        priority: null == priority
            ? _value.priority
            : priority // ignore: cast_nullable_to_non_nullable
                  as TaskPriority,
      ),
    );
  }
}

/// @nodoc

class _$TaskEntityImpl extends _TaskEntity {
  const _$TaskEntityImpl({
    required this.id,
    required this.title,
    this.description,
    required this.deadline,
    this.isCompleted = false,
    required this.createdAt,
    required this.updatedAt,
    this.reminderMinutes,
    this.priority = TaskPriority.medium,
  }) : super._();

  @override
  final String id;
  @override
  final String title;
  @override
  final String? description;
  @override
  final DateTime deadline;
  @override
  @JsonKey()
  final bool isCompleted;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final int? reminderMinutes;
  @override
  @JsonKey()
  final TaskPriority priority;

  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, description: $description, deadline: $deadline, isCompleted: $isCompleted, createdAt: $createdAt, updatedAt: $updatedAt, reminderMinutes: $reminderMinutes, priority: $priority)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.deadline, deadline) ||
                other.deadline == deadline) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.reminderMinutes, reminderMinutes) ||
                other.reminderMinutes == reminderMinutes) &&
            (identical(other.priority, priority) ||
                other.priority == priority));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    title,
    description,
    deadline,
    isCompleted,
    createdAt,
    updatedAt,
    reminderMinutes,
    priority,
  );

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      __$$TaskEntityImplCopyWithImpl<_$TaskEntityImpl>(this, _$identity);
}

abstract class _TaskEntity extends TaskEntity {
  const factory _TaskEntity({
    required final String id,
    required final String title,
    final String? description,
    required final DateTime deadline,
    final bool isCompleted,
    required final DateTime createdAt,
    required final DateTime updatedAt,
    final int? reminderMinutes,
    final TaskPriority priority,
  }) = _$TaskEntityImpl;
  const _TaskEntity._() : super._();

  @override
  String get id;
  @override
  String get title;
  @override
  String? get description;
  @override
  DateTime get deadline;
  @override
  bool get isCompleted;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  int? get reminderMinutes;
  @override
  TaskPriority get priority;

  /// Create a copy of TaskEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskEntityImplCopyWith<_$TaskEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
