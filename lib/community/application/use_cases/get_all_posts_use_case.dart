// community/application/use_cases/get_all_posts_use_case.dart
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';

class GetAllPostsUseCase {
  final PostRepository repo;

  GetAllPostsUseCase(this.repo);

  Future<List<Post>> execute({required String token}) {
    return repo.getAllPosts(token: token);
  }
}
