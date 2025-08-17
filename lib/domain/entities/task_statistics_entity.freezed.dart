// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_statistics_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$TaskStatisticsEntity {
  int get completedTasksToday => throw _privateConstructorUsedError;
  int get completedTasksThisWeek => throw _privateConstructorUsedError;
  int get completedTasksThisMonth => throw _privateConstructorUsedError;
  int get totalTasks => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  int get pendingTasks => throw _privateConstructorUsedError;
  int get overdueTasks => throw _privateConstructorUsedError;
  Map<int, int> get completedTasksByDay =>
      throw _privateConstructorUsedError; // day of week (1-7) -> count
  double get completionRate => throw _privateConstructorUsedError;
  int get mostProductiveDayOfWeek => throw _privateConstructorUsedError;

  /// Create a copy of TaskStatisticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TaskStatisticsEntityCopyWith<TaskStatisticsEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TaskStatisticsEntityCopyWith<$Res> {
  factory $TaskStatisticsEntityCopyWith(
    TaskStatisticsEntity value,
    $Res Function(TaskStatisticsEntity) then,
  ) = _$TaskStatisticsEntityCopyWithImpl<$Res, TaskStatisticsEntity>;
  @useResult
  $Res call({
    int completedTasksToday,
    int completedTasksThisWeek,
    int completedTasksThisMonth,
    int totalTasks,
    int completedTasks,
    int pendingTasks,
    int overdueTasks,
    Map<int, int> completedTasksByDay,
    double completionRate,
    int mostProductiveDayOfWeek,
  });
}

/// @nodoc
class _$TaskStatisticsEntityCopyWithImpl<
  $Res,
  $Val extends TaskStatisticsEntity
>
    implements $TaskStatisticsEntityCopyWith<$Res> {
  _$TaskStatisticsEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TaskStatisticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedTasksToday = null,
    Object? completedTasksThisWeek = null,
    Object? completedTasksThisMonth = null,
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? pendingTasks = null,
    Object? overdueTasks = null,
    Object? completedTasksByDay = null,
    Object? completionRate = null,
    Object? mostProductiveDayOfWeek = null,
  }) {
    return _then(
      _value.copyWith(
            completedTasksToday: null == completedTasksToday
                ? _value.completedTasksToday
                : completedTasksToday // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasksThisWeek: null == completedTasksThisWeek
                ? _value.completedTasksThisWeek
                : completedTasksThisWeek // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasksThisMonth: null == completedTasksThisMonth
                ? _value.completedTasksThisMonth
                : completedTasksThisMonth // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTasks: null == totalTasks
                ? _value.totalTasks
                : totalTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasks: null == completedTasks
                ? _value.completedTasks
                : completedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            pendingTasks: null == pendingTasks
                ? _value.pendingTasks
                : pendingTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            overdueTasks: null == overdueTasks
                ? _value.overdueTasks
                : overdueTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            completedTasksByDay: null == completedTasksByDay
                ? _value.completedTasksByDay
                : completedTasksByDay // ignore: cast_nullable_to_non_nullable
                      as Map<int, int>,
            completionRate: null == completionRate
                ? _value.completionRate
                : completionRate // ignore: cast_nullable_to_non_nullable
                      as double,
            mostProductiveDayOfWeek: null == mostProductiveDayOfWeek
                ? _value.mostProductiveDayOfWeek
                : mostProductiveDayOfWeek // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TaskStatisticsEntityImplCopyWith<$Res>
    implements $TaskStatisticsEntityCopyWith<$Res> {
  factory _$$TaskStatisticsEntityImplCopyWith(
    _$TaskStatisticsEntityImpl value,
    $Res Function(_$TaskStatisticsEntityImpl) then,
  ) = __$$TaskStatisticsEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int completedTasksToday,
    int completedTasksThisWeek,
    int completedTasksThisMonth,
    int totalTasks,
    int completedTasks,
    int pendingTasks,
    int overdueTasks,
    Map<int, int> completedTasksByDay,
    double completionRate,
    int mostProductiveDayOfWeek,
  });
}

/// @nodoc
class __$$TaskStatisticsEntityImplCopyWithImpl<$Res>
    extends _$TaskStatisticsEntityCopyWithImpl<$Res, _$TaskStatisticsEntityImpl>
    implements _$$TaskStatisticsEntityImplCopyWith<$Res> {
  __$$TaskStatisticsEntityImplCopyWithImpl(
    _$TaskStatisticsEntityImpl _value,
    $Res Function(_$TaskStatisticsEntityImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TaskStatisticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? completedTasksToday = null,
    Object? completedTasksThisWeek = null,
    Object? completedTasksThisMonth = null,
    Object? totalTasks = null,
    Object? completedTasks = null,
    Object? pendingTasks = null,
    Object? overdueTasks = null,
    Object? completedTasksByDay = null,
    Object? completionRate = null,
    Object? mostProductiveDayOfWeek = null,
  }) {
    return _then(
      _$TaskStatisticsEntityImpl(
        completedTasksToday: null == completedTasksToday
            ? _value.completedTasksToday
            : completedTasksToday // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasksThisWeek: null == completedTasksThisWeek
            ? _value.completedTasksThisWeek
            : completedTasksThisWeek // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasksThisMonth: null == completedTasksThisMonth
            ? _value.completedTasksThisMonth
            : completedTasksThisMonth // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTasks: null == totalTasks
            ? _value.totalTasks
            : totalTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasks: null == completedTasks
            ? _value.completedTasks
            : completedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        pendingTasks: null == pendingTasks
            ? _value.pendingTasks
            : pendingTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        overdueTasks: null == overdueTasks
            ? _value.overdueTasks
            : overdueTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        completedTasksByDay: null == completedTasksByDay
            ? _value._completedTasksByDay
            : completedTasksByDay // ignore: cast_nullable_to_non_nullable
                  as Map<int, int>,
        completionRate: null == completionRate
            ? _value.completionRate
            : completionRate // ignore: cast_nullable_to_non_nullable
                  as double,
        mostProductiveDayOfWeek: null == mostProductiveDayOfWeek
            ? _value.mostProductiveDayOfWeek
            : mostProductiveDayOfWeek // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$TaskStatisticsEntityImpl extends _TaskStatisticsEntity {
  const _$TaskStatisticsEntityImpl({
    required this.completedTasksToday,
    required this.completedTasksThisWeek,
    required this.completedTasksThisMonth,
    required this.totalTasks,
    required this.completedTasks,
    required this.pendingTasks,
    required this.overdueTasks,
    required final Map<int, int> completedTasksByDay,
    required this.completionRate,
    required this.mostProductiveDayOfWeek,
  }) : _completedTasksByDay = completedTasksByDay,
       super._();

  @override
  final int completedTasksToday;
  @override
  final int completedTasksThisWeek;
  @override
  final int completedTasksThisMonth;
  @override
  final int totalTasks;
  @override
  final int completedTasks;
  @override
  final int pendingTasks;
  @override
  final int overdueTasks;
  final Map<int, int> _completedTasksByDay;
  @override
  Map<int, int> get completedTasksByDay {
    if (_completedTasksByDay is EqualUnmodifiableMapView)
      return _completedTasksByDay;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completedTasksByDay);
  }

  // day of week (1-7) -> count
  @override
  final double completionRate;
  @override
  final int mostProductiveDayOfWeek;

  @override
  String toString() {
    return 'TaskStatisticsEntity(completedTasksToday: $completedTasksToday, completedTasksThisWeek: $completedTasksThisWeek, completedTasksThisMonth: $completedTasksThisMonth, totalTasks: $totalTasks, completedTasks: $completedTasks, pendingTasks: $pendingTasks, overdueTasks: $overdueTasks, completedTasksByDay: $completedTasksByDay, completionRate: $completionRate, mostProductiveDayOfWeek: $mostProductiveDayOfWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TaskStatisticsEntityImpl &&
            (identical(other.completedTasksToday, completedTasksToday) ||
                other.completedTasksToday == completedTasksToday) &&
            (identical(other.completedTasksThisWeek, completedTasksThisWeek) ||
                other.completedTasksThisWeek == completedTasksThisWeek) &&
            (identical(
                  other.completedTasksThisMonth,
                  completedTasksThisMonth,
                ) ||
                other.completedTasksThisMonth == completedTasksThisMonth) &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            (identical(other.pendingTasks, pendingTasks) ||
                other.pendingTasks == pendingTasks) &&
            (identical(other.overdueTasks, overdueTasks) ||
                other.overdueTasks == overdueTasks) &&
            const DeepCollectionEquality().equals(
              other._completedTasksByDay,
              _completedTasksByDay,
            ) &&
            (identical(other.completionRate, completionRate) ||
                other.completionRate == completionRate) &&
            (identical(
                  other.mostProductiveDayOfWeek,
                  mostProductiveDayOfWeek,
                ) ||
                other.mostProductiveDayOfWeek == mostProductiveDayOfWeek));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    completedTasksToday,
    completedTasksThisWeek,
    completedTasksThisMonth,
    totalTasks,
    completedTasks,
    pendingTasks,
    overdueTasks,
    const DeepCollectionEquality().hash(_completedTasksByDay),
    completionRate,
    mostProductiveDayOfWeek,
  );

  /// Create a copy of TaskStatisticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TaskStatisticsEntityImplCopyWith<_$TaskStatisticsEntityImpl>
  get copyWith =>
      __$$TaskStatisticsEntityImplCopyWithImpl<_$TaskStatisticsEntityImpl>(
        this,
        _$identity,
      );
}

abstract class _TaskStatisticsEntity extends TaskStatisticsEntity {
  const factory _TaskStatisticsEntity({
    required final int completedTasksToday,
    required final int completedTasksThisWeek,
    required final int completedTasksThisMonth,
    required final int totalTasks,
    required final int completedTasks,
    required final int pendingTasks,
    required final int overdueTasks,
    required final Map<int, int> completedTasksByDay,
    required final double completionRate,
    required final int mostProductiveDayOfWeek,
  }) = _$TaskStatisticsEntityImpl;
  const _TaskStatisticsEntity._() : super._();

  @override
  int get completedTasksToday;
  @override
  int get completedTasksThisWeek;
  @override
  int get completedTasksThisMonth;
  @override
  int get totalTasks;
  @override
  int get completedTasks;
  @override
  int get pendingTasks;
  @override
  int get overdueTasks;
  @override
  Map<int, int> get completedTasksByDay; // day of week (1-7) -> count
  @override
  double get completionRate;
  @override
  int get mostProductiveDayOfWeek;

  /// Create a copy of TaskStatisticsEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TaskStatisticsEntityImplCopyWith<_$TaskStatisticsEntityImpl>
  get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ProductivityTrend {
  DateTime get date => throw _privateConstructorUsedError;
  int get completedTasks => throw _privateConstructorUsedError;
  int get totalTasks => throw _privateConstructorUsedError;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductivityTrendCopyWith<ProductivityTrend> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductivityTrendCopyWith<$Res> {
  factory $ProductivityTrendCopyWith(
    ProductivityTrend value,
    $Res Function(ProductivityTrend) then,
  ) = _$ProductivityTrendCopyWithImpl<$Res, ProductivityTrend>;
  @useResult
  $Res call({DateTime date, int completedTasks, int totalTasks});
}

/// @nodoc
class _$ProductivityTrendCopyWithImpl<$Res, $Val extends ProductivityTrend>
    implements $ProductivityTrendCopyWith<$Res> {
  _$ProductivityTrendCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedTasks = null,
    Object? totalTasks = null,
  }) {
    return _then(
      _value.copyWith(
            date: null == date
                ? _value.date
                : date // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            completedTasks: null == completedTasks
                ? _value.completedTasks
                : completedTasks // ignore: cast_nullable_to_non_nullable
                      as int,
            totalTasks: null == totalTasks
                ? _value.totalTasks
                : totalTasks // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductivityTrendImplCopyWith<$Res>
    implements $ProductivityTrendCopyWith<$Res> {
  factory _$$ProductivityTrendImplCopyWith(
    _$ProductivityTrendImpl value,
    $Res Function(_$ProductivityTrendImpl) then,
  ) = __$$ProductivityTrendImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime date, int completedTasks, int totalTasks});
}

/// @nodoc
class __$$ProductivityTrendImplCopyWithImpl<$Res>
    extends _$ProductivityTrendCopyWithImpl<$Res, _$ProductivityTrendImpl>
    implements _$$ProductivityTrendImplCopyWith<$Res> {
  __$$ProductivityTrendImplCopyWithImpl(
    _$ProductivityTrendImpl _value,
    $Res Function(_$ProductivityTrendImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? completedTasks = null,
    Object? totalTasks = null,
  }) {
    return _then(
      _$ProductivityTrendImpl(
        date: null == date
            ? _value.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        completedTasks: null == completedTasks
            ? _value.completedTasks
            : completedTasks // ignore: cast_nullable_to_non_nullable
                  as int,
        totalTasks: null == totalTasks
            ? _value.totalTasks
            : totalTasks // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc

class _$ProductivityTrendImpl extends _ProductivityTrend {
  const _$ProductivityTrendImpl({
    required this.date,
    required this.completedTasks,
    required this.totalTasks,
  }) : super._();

  @override
  final DateTime date;
  @override
  final int completedTasks;
  @override
  final int totalTasks;

  @override
  String toString() {
    return 'ProductivityTrend(date: $date, completedTasks: $completedTasks, totalTasks: $totalTasks)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductivityTrendImpl &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.completedTasks, completedTasks) ||
                other.completedTasks == completedTasks) &&
            (identical(other.totalTasks, totalTasks) ||
                other.totalTasks == totalTasks));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, date, completedTasks, totalTasks);

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductivityTrendImplCopyWith<_$ProductivityTrendImpl> get copyWith =>
      __$$ProductivityTrendImplCopyWithImpl<_$ProductivityTrendImpl>(
        this,
        _$identity,
      );
}

abstract class _ProductivityTrend extends ProductivityTrend {
  const factory _ProductivityTrend({
    required final DateTime date,
    required final int completedTasks,
    required final int totalTasks,
  }) = _$ProductivityTrendImpl;
  const _ProductivityTrend._() : super._();

  @override
  DateTime get date;
  @override
  int get completedTasks;
  @override
  int get totalTasks;

  /// Create a copy of ProductivityTrend
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductivityTrendImplCopyWith<_$ProductivityTrendImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
