import 'package:freezed_annotation/freezed_annotation.dart';
import '../errors/failures.dart';

part 'result.freezed.dart';

@freezed
class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = ResultFailure<T>;
  
  const Result._();
  
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is ResultFailure<T>;
  
  T? get data => when(
    success: (data) => data,
    failure: (_) => null,
  );
  
  Failure? get failure => when(
    success: (_) => null,
    failure: (failure) => failure,
  );
  
  Result<R> transform<R>(R Function(T) mapper) {
    return when(
      success: (data) => Result.success(mapper(data)),
      failure: (failure) => Result.failure(failure),
    );
  }
  
  Result<R> flatMap<R>(Result<R> Function(T) mapper) {
    return when(
      success: mapper,
      failure: (failure) => Result.failure(failure),
    );
  }
  
  Future<Result<R>> flatMapAsync<R>(Future<Result<R>> Function(T) mapper) async {
    return when(
      success: mapper,
      failure: (failure) => Future.value(Result.failure(failure)),
    );
  }
}
