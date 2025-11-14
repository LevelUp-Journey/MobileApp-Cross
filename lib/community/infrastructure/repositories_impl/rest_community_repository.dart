// community/infrastructure/repositories_impl/rest_community_repository.dart
import '../../domain/entities/community.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/requests/community_requests.dart';
import '../datasources/community_remote_data_source.dart';

class RestCommunityRepository implements CommunityRepository {
  final CommunityRemoteDataSource _remote;

  RestCommunityRepository(this._remote);

  @override
  Future<List<Community>> getAllCommunities({required String token}) async {
    final dtos = await _remote.getAllCommunities(token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<List<Community>> getCommunitiesByCreator(String creatorId, {required String token}) async {
    final dtos = await _remote.getCommunitiesByCreator(creatorId, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<Community> getCommunityById(String communityId, {required String token}) async {
    final dto = await _remote.getCommunityById(communityId, token);
    return dto.toDomain();
  }

  @override
  Future<Community> createCommunity({
    required String ownerId,
    required String ownerProfileId,
    required CreateCommunityRequest request,
    required String token,
  }) async {
    final dto = await _remote.createCommunity(
      token: token,
      ownerId: ownerId,
      ownerProfileId: ownerProfileId,
      request: request,
    );
    return dto.toDomain();
  }

  @override
  Future<Community> updateCommunity({
    required UpdateCommunityRequest request,
    required String token,
  }) async {
    final dto = await _remote.updateCommunity(token: token, request: request);
    return dto.toDomain();
  }

  @override
  Future<void> deleteCommunity(String communityId, {required String token}) {
    return _remote.deleteCommunity(communityId, token);
  }
}
