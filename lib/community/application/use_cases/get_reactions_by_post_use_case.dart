// community/application/use_cases/get_reactions_by_post_use_case.dart
import '../../domain/entities/reaction.dart';
import '../../domain/repositories/reaction_repository.dart';

class GetReactionsByPostUseCase {
  final ReactionRepository repo;

  GetReactionsByPostUseCase(this.repo);

  Future<List<Reaction>> execute(String postId, {required String token}) {
    return repo.getReactionsByPost(postId, token: token);
  }
}
