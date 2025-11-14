// community/application/use_cases/update_community_use_case.dart
import '../../domain/entities/community.dart';
import '../../domain/requests/community_requests.dart';
import '../../domain/repositories/community_repository.dart';

class UpdateCommunityUseCase {
  final CommunityRepository repo;
  UpdateCommunityUseCase(this.repo);

  Future<Community> execute({
    required UpdateCommunityRequest request,
    required String token,
  }) {
    return repo.updateCommunity(
      request: request,
      token: token,
    );
  }
}
