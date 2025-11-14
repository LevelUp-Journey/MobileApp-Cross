// lib/shared/services/base_service.dart
import 'package:http/http.dart' as http;

import 'api_exception.dart';

abstract class BaseService {
  final http.Client client;
  final String baseUrl;

  BaseService(this.client, {required this.baseUrl});

  Uri buildUri(String path, {Map<String, String>? queryParameters}) {
    final uri = Uri.parse('$baseUrl$path');
    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }
    return uri.replace(queryParameters: {
      ...uri.queryParameters,
      ...queryParameters,
    });
  }

  Map<String, String> authorizedHeaders(String token, {Map<String, String>? extra}) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
      ...?extra,
    };
  }

  void ensureSuccess(
    http.Response response, {
    List<int> allowedStatusCodes = const [200],
    String? customMessage,
  }) {
    if (!allowedStatusCodes.contains(response.statusCode)) {
      throw ApiException(
        customMessage ?? 'Request failed',
        statusCode: response.statusCode,
        details: response.body,
      );
    }
  }
}