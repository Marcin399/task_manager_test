import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.database(String message) = DatabaseFailure;
  const factory Failure.validation(String message) = ValidationFailure;
  const factory Failure.notFound(String message) = NotFoundFailure;
  const factory Failure.unauthorized(String message) = UnauthorizedFailure;
  const factory Failure.unexpected(String message) = UnexpectedFailure;
}
