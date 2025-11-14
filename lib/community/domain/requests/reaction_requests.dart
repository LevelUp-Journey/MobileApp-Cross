// community/domain/requests/reaction_requests.dart
import '../entities/reaction.dart';

class CreateReactionRequest {
  final String userId;
  final String postId;
  final ReactionType type;

  const CreateReactionRequest({
    required this.userId,
    required this.postId,
    this.type = ReactionType.like,
  });
}
