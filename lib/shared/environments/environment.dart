// lib/shared/environments/environment.dart
class Environment {
  static const bool production = false; // Assuming dev for now
  static const String iamserverBaseUrl = 'http://localhost:8081';
  static const String signUpEndpoint = '/api/v1/authentication/sign-up';
  static const String signInEndpoint = '/api/v1/authentication/sign-in';
  static const String validateTokenEndpoint = '/api/v1/authentication/validate';
  static const String refreshTokenEndpoint = '/api/v1/authentication/refresh';
}