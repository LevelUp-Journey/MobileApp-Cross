// community/presentation/controllers/reaction_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/create_reaction_use_case.dart';
import '../../application/use_cases/delete_reaction_use_case.dart';
import '../../application/use_cases/get_reactions_by_post_use_case.dart';
import '../../domain/entities/reaction.dart';
import '../../domain/requests/reaction_requests.dart';
import 'providers.dart';
import 'reaction_state.dart';

class ReactionController extends Notifier<ReactionState> {
  @override
  ReactionState build() => const ReactionState();

  Future<void> fetchReactions(String postId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getReactionsByPostUseCaseProvider);
      final token = _requireToken();
      final reactions = await useCase.execute(postId, token: token);
      _updateReactions(postId, reactions);
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> addReaction(String postId, {ReactionType type = ReactionType.like}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(createReactionUseCaseProvider);
      final token = _requireToken();
      final userId = _requireUserId();
      final reaction = await useCase.execute(
        CreateReactionRequest(userId: userId, postId: postId, type: type),
        token: token,
      );
      if (reaction != null) {
        final existing = List<Reaction>.from(state.reactionsByPost[postId] ?? const []);
        existing.add(reaction);
        _updateReactions(postId, existing);
      }
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> deleteReaction(String postId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(deleteReactionUseCaseProvider);
      final token = _requireToken();
      final userId = _requireUserId();
      final deleted = await useCase.execute(userId, postId, token: token);
      if (deleted) {
        final existing = List<Reaction>.from(state.reactionsByPost[postId] ?? const []);
        existing.removeWhere((reaction) => reaction.userId == userId);
        _updateReactions(postId, existing);
      }
      state = state.copyWith(loading: false);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  void _updateReactions(String postId, List<Reaction> reactions) {
    final updated = Map<String, List<Reaction>>.from(state.reactionsByPost);
    updated[postId] = reactions;
    state = state.copyWith(reactionsByPost: updated);
  }

  String _requireToken() {
    final authState = ref.read(authControllerProvider);
    final token = authState.token ?? authState.user?.token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }

  String _requireUserId() {
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id;
    if (userId == null) throw Exception('User not authenticated');
    return userId;
  }
}
