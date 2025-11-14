// community/domain/repositories/reaction_repository.dart
import '../entities/reaction.dart';
import '../requests/reaction_requests.dart';

abstract class ReactionRepository {
  Future<Reaction?> createReaction(CreateReactionRequest request, {required String token});
  Future<List<Reaction>> getReactionsByPost(String postId, {required String token});
  Future<bool> deleteReaction(String userId, String postId, {required String token});
}
