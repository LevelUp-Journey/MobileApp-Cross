// community/infrastructure/datasources/community_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../../shared/services/base_service.dart';
import '../../domain/requests/community_requests.dart';
import '../dtos/community_dto.dart';

class CommunityRemoteDataSource extends BaseService {
  CommunityRemoteDataSource(http.Client client, {required String baseUrl})
      : super(client, baseUrl: baseUrl);

  Future<List<CommunityDto>> getAllCommunities(String token) async {
    final response = await client.get(
      buildUri(Environment.getAllCommunitiesEndpoint),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => CommunityDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<CommunityDto>> getCommunitiesByCreator(String creatorId, String token) async {
    final response = await client.get(
      buildUri(Environment.communitiesByCreator(creatorId)),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => CommunityDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<CommunityDto> getCommunityById(String id, String token) async {
    final response = await client.get(
      buildUri(Environment.communityById(id)),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return CommunityDto.fromJson(data);
  }

  Future<CommunityDto> createCommunity({
    required String token,
    required String ownerId,
    required String ownerProfileId,
    required CreateCommunityRequest request,
  }) async {
    final response = await client.post(
      buildUri(Environment.getAllCommunitiesEndpoint),
      headers: authorizedHeaders(token),
      body: jsonEncode({
        'ownerId': ownerId,
        'ownerProfileId': ownerProfileId,
        'name': request.name,
        'description': request.description,
        if (request.imageUrl != null) 'imageUrl': request.imageUrl,
      }),
    );
    ensureSuccess(response, allowedStatusCodes: const [200, 201]);
    return CommunityDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<CommunityDto> updateCommunity({
    required String token,
    required UpdateCommunityRequest request,
  }) async {
    final response = await client.put(
      buildUri(Environment.communityById(request.communityId)),
      headers: authorizedHeaders(token),
      body: jsonEncode({
        'name': request.name,
        'description': request.description,
        if (request.imageUrl != null) 'imageUrl': request.imageUrl,
      }),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    return CommunityDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deleteCommunity(String communityId, String token) async {
    final response = await client.delete(
      buildUri(Environment.communityById(communityId)),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200, 204]);
  }
}
