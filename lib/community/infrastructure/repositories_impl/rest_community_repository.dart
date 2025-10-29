// community/infrastructure/repositories_impl/rest_community_repository.dart
import 'dart:convert';
import '../../../shared/services/base_service.dart';
import '../../../shared/environments/environment.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/community.dart';

class RestCommunityRepository extends BaseService implements CommunityRepository {
  RestCommunityRepository(super.client, {required super.baseUrl});

  @override
  Future<List<Community>> getAllCommunities({required String token}) async {
    final resp = await client.get(
      buildUri(Environment.getAllCommunitiesEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
      return data.map((json) => _communityFromJson(json as Map<String, dynamic>)).toList();
    } else {
      throw Exception('Failed to load communities: Server returned ${resp.statusCode}');
    }
  }

  @override
  Future<Community> getCommunityById(String communityId, {required String token}) async {
    final resp = await client.get(
      buildUri('${Environment.getAllCommunitiesEndpoint}/$communityId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return _communityFromJson(data);
    } else if (resp.statusCode == 404) {
      throw Exception('Community not found');
    } else if (resp.statusCode == 400) {
      throw Exception('Invalid community ID format');
    } else {
      throw Exception('Failed to load community: Server returned ${resp.statusCode}');
    }
  }

  @override
  Future<Community> createCommunity({
    required String ownerId,
    required String ownerProfileId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  }) async {
    final resp = await client.post(
      buildUri(Environment.getAllCommunitiesEndpoint),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'ownerId': ownerId,
        'ownerProfileId': ownerProfileId,
        'name': name,
        'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      }),
    );

    if (resp.statusCode == 201) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return _communityFromJson(data);
    } else if (resp.statusCode == 400) {
      throw Exception('Invalid input data or community already exists');
    } else if (resp.statusCode == 409) {
      throw Exception('Community with this ID already exists');
    } else if (resp.statusCode == 500) {
      throw Exception('Internal server error');
    } else {
      throw Exception('Failed to create community: Server returned ${resp.statusCode}');
    }
  }

  @override
  Future<Community> updateCommunity({
    required String communityId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  }) async {
    final resp = await client.put(
      buildUri('${Environment.getAllCommunitiesEndpoint}/$communityId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'name': name,
        'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
      }),
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body) as Map<String, dynamic>;
      return _communityFromJson(data);
    } else if (resp.statusCode == 400) {
      throw Exception('Invalid input data');
    } else if (resp.statusCode == 404) {
      throw Exception('Community not found');
    } else {
      throw Exception('Failed to update community: Server returned ${resp.statusCode}');
    }
  }

  Community _communityFromJson(Map<String, dynamic> json) {
    return Community(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      ownerProfileId: json['ownerProfileId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
