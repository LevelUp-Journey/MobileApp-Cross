// iam/domain/services/jwt_decoder_service.dart
import 'dart:convert';

class JwtDecoderService {
  Map<String, dynamic> decode(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT token format');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  List<String> extractRoles(String token) {
    try {
      final payload = decode(token);
      final roles = payload['roles'];

      if (roles == null) return [];
      if (roles is List) {
        return roles.map((e) => e.toString()).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  String? extractClaim(String token, String claimName) {
    try {
      final payload = decode(token);
      return payload[claimName]?.toString();
    } catch (e) {
      return null;
    }
  }
}
