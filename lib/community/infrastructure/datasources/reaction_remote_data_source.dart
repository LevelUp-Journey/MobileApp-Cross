// community/infrastructure/datasources/reaction_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../../shared/services/api_exception.dart';
import '../../../shared/services/base_service.dart';
import '../../domain/entities/reaction.dart';
import '../../domain/requests/reaction_requests.dart';
import '../dtos/reaction_dto.dart';

class ReactionRemoteDataSource extends BaseService {
  ReactionRemoteDataSource(http.Client client, {required String baseUrl})
      : super(client, baseUrl: baseUrl);

  Future<ReactionDto?> createReaction(CreateReactionRequest request, String token) async {
    final response = await client.post(
      buildUri(Environment.reactionForUserPost(request.userId, request.postId)),
      headers: authorizedHeaders(token),
      body: jsonEncode({'type': request.type.value}),
    );

    if (response.statusCode == 201) {
      return ReactionDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    }

    if (response.statusCode == 409) {
      return null; // duplicate reaction
    }

    throw ApiException(
      'Failed to create reaction',
      statusCode: response.statusCode,
      details: response.body,
    );
  }

  Future<List<ReactionDto>> getReactionsByPost(String postId, String token) async {
    final response = await client.get(
      buildUri(Environment.reactionsByPost(postId)),
      headers: authorizedHeaders(token),
    );

    if (response.statusCode == 400) {
      return const [];
    }

    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => ReactionDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<bool> deleteReaction(String userId, String postId, String token) async {
    final response = await client.delete(
      buildUri(Environment.reactionForUserPost(userId, postId)),
      headers: authorizedHeaders(token),
    );

    if (response.statusCode == 404) {
      return false;
    }

    ensureSuccess(response, allowedStatusCodes: const [200, 204]);
    return true;
  }
}
