// community/application/use_cases/delete_reaction_use_case.dart
import '../../domain/repositories/reaction_repository.dart';

class DeleteReactionUseCase {
  final ReactionRepository repo;

  DeleteReactionUseCase(this.repo);

  Future<bool> execute(String userId, String postId, {required String token}) {
    return repo.deleteReaction(userId, postId, token: token);
  }
}
