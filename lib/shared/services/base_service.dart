// lib/shared/base_service.dart
import 'package:http/http.dart' as http;

abstract class BaseService {
  final http.Client client;
  final String baseUrl;

  BaseService(this.client, {required this.baseUrl});

  Uri buildUri(String path) {
    return Uri.parse('$baseUrl$path');
  }
}