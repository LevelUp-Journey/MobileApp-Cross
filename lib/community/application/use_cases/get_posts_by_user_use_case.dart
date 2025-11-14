// community/application/use_cases/get_posts_by_user_use_case.dart
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

class GetPostsByUserUseCase {
  final PostRepository repo;

  GetPostsByUserUseCase(this.repo);

  Future<List<Post>> execute(String userId, {required String token}) {
    return repo.getPostsByUser(userId, token: token);
  }
}
