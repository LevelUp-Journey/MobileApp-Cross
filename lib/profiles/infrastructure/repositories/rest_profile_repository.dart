import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../../shared/environments/environment.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class RestProfileRepository implements ProfileRepository {
  final http.Client client;

  RestProfileRepository(this.client);

  @override
  Future<Profile> getProfileByUserId(String userId, {required String token}) async {
    final uri = Uri.parse(
        '${Environment.profileserverBaseUrl}${Environment.getProfileByUserIdEndpoint}/$userId');
    if (kDebugMode) {
      print('Requesting profile from: $uri');
    }
    final response = await client.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });
    if (kDebugMode) {
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
