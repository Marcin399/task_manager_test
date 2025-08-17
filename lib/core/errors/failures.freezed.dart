// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$Failure {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) => throw _privateConstructorUsedError;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FailureCopyWith<Failure> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FailureCopyWith<$Res> {
  factory $FailureCopyWith(Failure value, $Res Function(Failure) then) =
      _$FailureCopyWithImpl<$Res, Failure>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$FailureCopyWithImpl<$Res, $Val extends Failure>
    implements $FailureCopyWith<$Res> {
  _$FailureCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _value.copyWith(
            message: null == message
                ? _value.message
                : message // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DatabaseFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$DatabaseFailureImplCopyWith(
    _$DatabaseFailureImpl value,
    $Res Function(_$DatabaseFailureImpl) then,
  ) = __$$DatabaseFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$DatabaseFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$DatabaseFailureImpl>
    implements _$$DatabaseFailureImplCopyWith<$Res> {
  __$$DatabaseFailureImplCopyWithImpl(
    _$DatabaseFailureImpl _value,
    $Res Function(_$DatabaseFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$DatabaseFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$DatabaseFailureImpl implements DatabaseFailure {
  const _$DatabaseFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.database(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DatabaseFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      __$$DatabaseFailureImplCopyWithImpl<_$DatabaseFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) {
    return database(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) {
    return database?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return database(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return database?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (database != null) {
      return database(this);
    }
    return orElse();
  }
}

abstract class DatabaseFailure implements Failure {
  const factory DatabaseFailure(final String message) = _$DatabaseFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DatabaseFailureImplCopyWith<_$DatabaseFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ValidationFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$ValidationFailureImplCopyWith(
    _$ValidationFailureImpl value,
    $Res Function(_$ValidationFailureImpl) then,
  ) = __$$ValidationFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ValidationFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$ValidationFailureImpl>
    implements _$$ValidationFailureImplCopyWith<$Res> {
  __$$ValidationFailureImplCopyWithImpl(
    _$ValidationFailureImpl _value,
    $Res Function(_$ValidationFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$ValidationFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ValidationFailureImpl implements ValidationFailure {
  const _$ValidationFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.validation(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ValidationFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      __$$ValidationFailureImplCopyWithImpl<_$ValidationFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) {
    return validation(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) {
    return validation?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return validation(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return validation?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (validation != null) {
      return validation(this);
    }
    return orElse();
  }
}

abstract class ValidationFailure implements Failure {
  const factory ValidationFailure(final String message) =
      _$ValidationFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ValidationFailureImplCopyWith<_$ValidationFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$NotFoundFailureImplCopyWith(
    _$NotFoundFailureImpl value,
    $Res Function(_$NotFoundFailureImpl) then,
  ) = __$$NotFoundFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$NotFoundFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$NotFoundFailureImpl>
    implements _$$NotFoundFailureImplCopyWith<$Res> {
  __$$NotFoundFailureImplCopyWithImpl(
    _$NotFoundFailureImpl _value,
    $Res Function(_$NotFoundFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$NotFoundFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$NotFoundFailureImpl implements NotFoundFailure {
  const _$NotFoundFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.notFound(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      __$$NotFoundFailureImplCopyWithImpl<_$NotFoundFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) {
    return notFound(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) {
    return notFound?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundFailure implements Failure {
  const factory NotFoundFailure(final String message) = _$NotFoundFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotFoundFailureImplCopyWith<_$NotFoundFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnauthorizedFailureImplCopyWith(
    _$UnauthorizedFailureImpl value,
    $Res Function(_$UnauthorizedFailureImpl) then,
  ) = __$$UnauthorizedFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnauthorizedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnauthorizedFailureImpl>
    implements _$$UnauthorizedFailureImplCopyWith<$Res> {
  __$$UnauthorizedFailureImplCopyWithImpl(
    _$UnauthorizedFailureImpl _value,
    $Res Function(_$UnauthorizedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnauthorizedFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnauthorizedFailureImpl implements UnauthorizedFailure {
  const _$UnauthorizedFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unauthorized(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedFailureImplCopyWith<_$UnauthorizedFailureImpl> get copyWith =>
      __$$UnauthorizedFailureImplCopyWithImpl<_$UnauthorizedFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) {
    return unauthorized(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) {
    return unauthorized?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedFailure implements Failure {
  const factory UnauthorizedFailure(final String message) =
      _$UnauthorizedFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnauthorizedFailureImplCopyWith<_$UnauthorizedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnexpectedFailureImplCopyWith<$Res>
    implements $FailureCopyWith<$Res> {
  factory _$$UnexpectedFailureImplCopyWith(
    _$UnexpectedFailureImpl value,
    $Res Function(_$UnexpectedFailureImpl) then,
  ) = __$$UnexpectedFailureImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$UnexpectedFailureImplCopyWithImpl<$Res>
    extends _$FailureCopyWithImpl<$Res, _$UnexpectedFailureImpl>
    implements _$$UnexpectedFailureImplCopyWith<$Res> {
  __$$UnexpectedFailureImplCopyWithImpl(
    _$UnexpectedFailureImpl _value,
    $Res Function(_$UnexpectedFailureImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? message = null}) {
    return _then(
      _$UnexpectedFailureImpl(
        null == message
            ? _value.message
            : message // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$UnexpectedFailureImpl implements UnexpectedFailure {
  const _$UnexpectedFailureImpl(this.message);

  @override
  final String message;

  @override
  String toString() {
    return 'Failure.unexpected(message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnexpectedFailureImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      __$$UnexpectedFailureImplCopyWithImpl<_$UnexpectedFailureImpl>(
        this,
        _$identity,
      );

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message) database,
    required TResult Function(String message) validation,
    required TResult Function(String message) notFound,
    required TResult Function(String message) unauthorized,
    required TResult Function(String message) unexpected,
  }) {
    return unexpected(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message)? database,
    TResult? Function(String message)? validation,
    TResult? Function(String message)? notFound,
    TResult? Function(String message)? unauthorized,
    TResult? Function(String message)? unexpected,
  }) {
    return unexpected?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message)? database,
    TResult Function(String message)? validation,
    TResult Function(String message)? notFound,
    TResult Function(String message)? unauthorized,
    TResult Function(String message)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(DatabaseFailure value) database,
    required TResult Function(ValidationFailure value) validation,
    required TResult Function(NotFoundFailure value) notFound,
    required TResult Function(UnauthorizedFailure value) unauthorized,
    required TResult Function(UnexpectedFailure value) unexpected,
  }) {
    return unexpected(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(DatabaseFailure value)? database,
    TResult? Function(ValidationFailure value)? validation,
    TResult? Function(NotFoundFailure value)? notFound,
    TResult? Function(UnauthorizedFailure value)? unauthorized,
    TResult? Function(UnexpectedFailure value)? unexpected,
  }) {
    return unexpected?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(DatabaseFailure value)? database,
    TResult Function(ValidationFailure value)? validation,
    TResult Function(NotFoundFailure value)? notFound,
    TResult Function(UnauthorizedFailure value)? unauthorized,
    TResult Function(UnexpectedFailure value)? unexpected,
    required TResult orElse(),
  }) {
    if (unexpected != null) {
      return unexpected(this);
    }
    return orElse();
  }
}

abstract class UnexpectedFailure implements Failure {
  const factory UnexpectedFailure(final String message) =
      _$UnexpectedFailureImpl;

  @override
  String get message;

  /// Create a copy of Failure
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UnexpectedFailureImplCopyWith<_$UnexpectedFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
