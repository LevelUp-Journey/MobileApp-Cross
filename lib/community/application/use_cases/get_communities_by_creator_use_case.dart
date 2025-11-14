// community/application/use_cases/get_communities_by_creator_use_case.dart
import '../../domain/entities/community.dart';
import '../../domain/repositories/community_repository.dart';

class GetCommunitiesByCreatorUseCase {
  final CommunityRepository repo;

  GetCommunitiesByCreatorUseCase(this.repo);

  Future<List<Community>> execute(String creatorId, {required String token}) {
    return repo.getCommunitiesByCreator(creatorId, token: token);
  }
}
