// community/application/use_cases/create_community_use_case.dart
import '../../domain/entities/community.dart';
import '../../domain/requests/community_requests.dart';
import '../../domain/repositories/community_repository.dart';

class CreateCommunityUseCase {
  final CommunityRepository repo;
  CreateCommunityUseCase(this.repo);

  Future<Community> execute({
    required String ownerId,
    required String ownerProfileId,
    required CreateCommunityRequest request,
    required String token,
  }) {
    return repo.createCommunity(
      ownerId: ownerId,
      ownerProfileId: ownerProfileId,
      request: request,
      token: token,
    );
  }
}
