class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message${code != null ? ' (Code: $code)' : ''}';
}

class DatabaseException extends AppException {
  const DatabaseException(super.message, [super.code]);
}

class ValidationException extends AppException {
  const ValidationException(super.message, [super.code]);
}

class NotFoundException extends AppException {
  const NotFoundException(super.message, [super.code]);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException(super.message, [super.code]);
}
