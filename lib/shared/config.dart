// lib/shared/config.dart
import 'environments/environment.dart';

class Config {
  static String get baseUrl => Environment.iamserverBaseUrl;
  static String get profileBaseUrl => Environment.profileserverBaseUrl;
}