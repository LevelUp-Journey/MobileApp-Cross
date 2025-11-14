// community/domain/repositories/post_repository.dart
import '../entities/paginated_result.dart';
import '../entities/post.dart';
import '../requests/post_requests.dart';

abstract class PostRepository {
  Future<List<Post>> getAllPosts({required String token});
  Future<PaginatedResult<Post>> getPostsByCommunity(CommunityPostsQuery query, {required String token});
  Future<List<Post>> getPostsByUser(String userId, {required String token});
  Future<List<Post>> getFeedPosts(FeedPostsQuery query, {required String token});
  Future<Post> createPost({
    required String authorId,
    required CreatePostRequest request,
    required String token,
  });
  Future<void> deletePost(String postId, {required String token});
}
