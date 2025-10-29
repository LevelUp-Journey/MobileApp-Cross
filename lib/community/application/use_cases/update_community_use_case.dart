// community/application/use_cases/update_community_use_case.dart
import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/community.dart';

class UpdateCommunityUseCase {
  final CommunityRepository repo;
  UpdateCommunityUseCase(this.repo);

  Future<Community> execute({
    required String communityId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  }) {
    return repo.updateCommunity(
      communityId: communityId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      token: token,
    );
  }
}
