// community/presentation/controllers/reaction_state.dart
import '../../domain/entities/reaction.dart';

class ReactionState {
  final bool loading;
  final Map<String, List<Reaction>> reactionsByPost;
  final String? error;

  const ReactionState({
    this.loading = false,
    this.reactionsByPost = const {},
    this.error,
  });

  ReactionState copyWith({
    bool? loading,
    Map<String, List<Reaction>>? reactionsByPost,
    String? error,
  }) {
    return ReactionState(
      loading: loading ?? this.loading,
      reactionsByPost: reactionsByPost ?? this.reactionsByPost,
      error: error,
    );
  }
}
