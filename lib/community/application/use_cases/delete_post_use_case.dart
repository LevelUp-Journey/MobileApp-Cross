// community/application/use_cases/delete_post_use_case.dart
import '../../domain/repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository repo;

  DeletePostUseCase(this.repo);

  Future<void> execute(String postId, {required String token}) {
    return repo.deletePost(postId, token: token);
  }
}
