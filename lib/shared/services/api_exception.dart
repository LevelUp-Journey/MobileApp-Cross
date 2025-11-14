// lib/shared/services/api_exception.dart
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Object? details;

  const ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException(statusCode: $statusCode, message: $message)';
}
