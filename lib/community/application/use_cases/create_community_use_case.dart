// community/application/use_cases/create_community_use_case.dart
import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/community.dart';

class CreateCommunityUseCase {
  final CommunityRepository repo;
  CreateCommunityUseCase(this.repo);

  Future<Community> execute({
    required String ownerId,
    required String ownerProfileId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  }) {
    return repo.createCommunity(
      ownerId: ownerId,
      ownerProfileId: ownerProfileId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      token: token,
    );
  }
}
