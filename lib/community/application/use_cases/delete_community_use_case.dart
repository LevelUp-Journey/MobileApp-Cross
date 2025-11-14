// community/application/use_cases/delete_community_use_case.dart
import '../../domain/repositories/community_repository.dart';

class DeleteCommunityUseCase {
  final CommunityRepository repo;

  DeleteCommunityUseCase(this.repo);

  Future<void> execute(String communityId, {required String token}) {
    return repo.deleteCommunity(communityId, token: token);
  }
}
