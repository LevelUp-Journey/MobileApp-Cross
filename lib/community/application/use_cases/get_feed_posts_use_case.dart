// community/application/use_cases/get_feed_posts_use_case.dart
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/requests/post_requests.dart';

class GetFeedPostsUseCase {
  final PostRepository repo;

  GetFeedPostsUseCase(this.repo);

  Future<List<Post>> execute(FeedPostsQuery query, {required String token}) {
    return repo.getFeedPosts(query, token: token);
  }
}
