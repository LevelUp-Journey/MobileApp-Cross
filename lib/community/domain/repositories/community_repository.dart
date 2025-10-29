// community/domain/repositories/community_repository.dart
import '../entities/community.dart';

abstract class CommunityRepository {
  Future<List<Community>> getAllCommunities({required String token});
  Future<Community> getCommunityById(String communityId, {required String token});
  Future<Community> createCommunity({
    required String ownerId,
    required String ownerProfileId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  });
  Future<Community> updateCommunity({
    required String communityId,
    required String name,
    required String description,
    String? imageUrl,
    required String token,
  });
}
