// community/application/use_cases/create_reaction_use_case.dart
import '../../domain/entities/reaction.dart';
import '../../domain/repositories/reaction_repository.dart';
import '../../domain/requests/reaction_requests.dart';

class CreateReactionUseCase {
  final ReactionRepository repo;

  CreateReactionUseCase(this.repo);

  Future<Reaction?> execute(CreateReactionRequest request, {required String token}) {
    return repo.createReaction(request, token: token);
  }
}
