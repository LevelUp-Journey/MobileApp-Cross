// community/application/use_cases/get_posts_by_community_use_case.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/requests/post_requests.dart';

class GetPostsByCommunityUseCase {
  final PostRepository repo;

  GetPostsByCommunityUseCase(this.repo);

  Future<PaginatedResult<Post>> execute(CommunityPostsQuery query, {required String token}) {
    return repo.getPostsByCommunity(query, token: token);
  }
}
