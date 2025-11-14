// community/domain/repositories/community_repository.dart
import '../entities/community.dart';
import '../requests/community_requests.dart';

abstract class CommunityRepository {
  Future<List<Community>> getAllCommunities({required String token});
  Future<List<Community>> getCommunitiesByCreator(String creatorId, {required String token});
  Future<Community> getCommunityById(String communityId, {required String token});
  Future<Community> createCommunity({
    required String ownerId,
    required String ownerProfileId,
    required CreateCommunityRequest request,
    required String token,
  });
  Future<Community> updateCommunity({
    required UpdateCommunityRequest request,
    required String token,
  });
  Future<void> deleteCommunity(String communityId, {required String token});
}
