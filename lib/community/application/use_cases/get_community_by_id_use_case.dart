// community/application/use_cases/get_community_by_id_use_case.dart
import '../../domain/repositories/community_repository.dart';
import '../../domain/entities/community.dart';

class GetCommunityByIdUseCase {
  final CommunityRepository repo;
  GetCommunityByIdUseCase(this.repo);

  Future<Community> execute(String communityId, {required String token}) {
    return repo.getCommunityById(communityId, token: token);
  }
}
