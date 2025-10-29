// community/application/use_cases/get_all_communities_use_case.dart
import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/community.dart';

class GetAllCommunitiesUseCase {
  final CommunityRepository repo;
  GetAllCommunitiesUseCase(this.repo);

  Future<List<Community>> execute({required String token}) {
    return repo.getAllCommunities(token: token);
  }
}
