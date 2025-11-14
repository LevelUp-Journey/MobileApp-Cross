// community/infrastructure/datasources/post_remote_data_source.dart
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../../shared/services/base_service.dart';
import '../../domain/requests/post_requests.dart';
import '../dtos/paginated_response_dto.dart';
import '../dtos/post_dto.dart';

class PostRemoteDataSource extends BaseService {
  PostRemoteDataSource(http.Client client, {required String baseUrl})
      : super(client, baseUrl: baseUrl);

  Future<List<PostDto>> getAllPosts(String token) async {
    final response = await client.get(
      buildUri(Environment.postsEndpoint),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => PostDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<PaginatedResponseDto<PostDto>> getPostsByCommunity(
    CommunityPostsQuery query,
    String token,
  ) async {
    final response = await client.get(
      buildUri(
        Environment.postsByCommunity(query.communityId),
        queryParameters: {
          'page': query.pagination.page.toString(),
          'size': query.pagination.size.toString(),
        },
      ),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PaginatedResponseDto<PostDto>.fromJson(
      data,
      (json) => PostDto.fromJson(json),
    );
  }

  Future<List<PostDto>> getPostsByUser(String userId, String token) async {
    final response = await client.get(
      buildUri(
        Environment.postsEndpoint,
        queryParameters: {
          'authorId': userId,
        },
      ),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => PostDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<PostDto>> getFeedPosts(FeedPostsQuery query, String token) async {
    final response = await client.get(
      buildUri(
        Environment.postsFeed(query.userId),
        queryParameters: {
          'limit': query.offsetQuery.limit.toString(),
          'offset': query.offsetQuery.offset.toString(),
        },
      ),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200]);
    final data = jsonDecode(response.body) as List<dynamic>;
    return data.map((json) => PostDto.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<PostDto> createPost({
    required String token,
    required String authorId,
    required CreatePostRequest request,
  }) async {
    final response = await client.post(
      buildUri(Environment.postsEndpoint),
      headers: authorizedHeaders(token),
      body: jsonEncode({
        'communityId': request.communityId,
        'content': request.content,
        'authorId': authorId,
        if (request.imageUrl != null) 'imageUrl': request.imageUrl,
      }),
    );
    ensureSuccess(response, allowedStatusCodes: const [200, 201]);
    return PostDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> deletePost(String postId, String token) async {
    final response = await client.delete(
      buildUri('${Environment.postsEndpoint}/$postId'),
      headers: authorizedHeaders(token),
    );
    ensureSuccess(response, allowedStatusCodes: const [200, 204]);
  }
}
