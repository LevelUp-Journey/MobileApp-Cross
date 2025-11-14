import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../shared/config.dart';
import '../../../shared/environments/environment.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';

class RestProfileRepository implements ProfileRepository {
  final http.Client client;

  RestProfileRepository(this.client);

  @override
  Future<Profile> getProfileByUserId(String userId, {required String token}) async {
    final uri = Uri.parse(
        '${Config.baseUrl}${Environment.getProfileByUserIdEndpoint}/$userId');
    final response = await client.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load profile');
    }
  }

  @override
  Future<Profile> updateProfile(Profile profile, {required String token}) async {
    final uri = Uri.parse(
        '${Config.baseUrl}${Environment.updateProfileEndpoint}/${profile.id}');
    final response = await client.put(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(profile.toJson()),
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update profile');
    }
  }
}
