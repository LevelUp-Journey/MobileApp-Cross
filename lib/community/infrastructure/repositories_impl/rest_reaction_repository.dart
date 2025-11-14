// community/infrastructure/repositories_impl/rest_reaction_repository.dart
import '../../domain/entities/reaction.dart';
import '../../domain/repositories/reaction_repository.dart';
import '../../domain/requests/reaction_requests.dart';
import '../datasources/reaction_remote_data_source.dart';

class RestReactionRepository implements ReactionRepository {
  final ReactionRemoteDataSource _remote;

  RestReactionRepository(this._remote);

  @override
  Future<Reaction?> createReaction(CreateReactionRequest request, {required String token}) async {
    final dto = await _remote.createReaction(request, token);
    return dto?.toDomain();
  }

  @override
  Future<List<Reaction>> getReactionsByPost(String postId, {required String token}) async {
    final dtos = await _remote.getReactionsByPost(postId, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<bool> deleteReaction(String userId, String postId, {required String token}) {
    return _remote.deleteReaction(userId, postId, token);
  }
}
