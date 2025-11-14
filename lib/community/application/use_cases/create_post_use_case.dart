// community/application/use_cases/create_post_use_case.dart
import '../../domain/entities/post.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/requests/post_requests.dart';

class CreatePostUseCase {
  final PostRepository repo;

  CreatePostUseCase(this.repo);

  Future<Post> execute({
    required String authorId,
    required CreatePostRequest request,
    required String token,
  }) {
    return repo.createPost(authorId: authorId, request: request, token: token);
  }
}
