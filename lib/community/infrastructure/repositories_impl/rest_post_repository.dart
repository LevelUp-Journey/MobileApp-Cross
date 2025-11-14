// community/infrastructure/repositories_impl/rest_post_repository.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/requests/post_requests.dart';
import '../datasources/post_remote_data_source.dart';

class RestPostRepository implements PostRepository {
  final PostRemoteDataSource _remote;

  RestPostRepository(this._remote);

  @override
  Future<List<Post>> getAllPosts({required String token}) async {
    final dtos = await _remote.getAllPosts(token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<PaginatedResult<Post>> getPostsByCommunity(
    CommunityPostsQuery query, {
    required String token,
  }) async {
    final dto = await _remote.getPostsByCommunity(query, token);
    final posts = dto.items.map((postDto) => postDto.toDomain()).toList();
    return dto.toDomain(posts);
  }

  @override
  Future<List<Post>> getPostsByUser(String userId, {required String token}) async {
    final dtos = await _remote.getPostsByUser(userId, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Post>> getFeedPosts(FeedPostsQuery query, {required String token}) async {
    final dtos = await _remote.getFeedPosts(query, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Post> createPost({
    required String authorId,
    required CreatePostRequest request,
    required String token,
  }) async {
    final dto = await _remote.createPost(
      token: token,
      authorId: authorId,
      request: request,
    );
    return dto.toDomain();
  }

  @override
  Future<void> deletePost(String postId, {required String token}) {
    return _remote.deletePost(postId, token);
  }
}
