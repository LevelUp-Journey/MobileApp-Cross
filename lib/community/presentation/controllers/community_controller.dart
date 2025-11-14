// community/presentation/controllers/community_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../iam/presentation/controllers/providers.dart';
import '../../domain/entities/community.dart';
import '../../domain/requests/community_requests.dart';
import 'community_state.dart';
import 'providers.dart';

class CommunityController extends Notifier<CommunityState> {
  @override
  CommunityState build() {
    return const CommunityState();
  }

  Future<void> fetchAllCommunities() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final getAllCommunities = ref.read(getAllCommunitiesUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;

      if (token == null) {
        throw Exception('User not authenticated or token not found');
      }

      final communities = await getAllCommunities.execute(token: token);
      state = state.copyWith(loading: false, communities: communities);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> fetchCommunityById(String communityId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final getCommunityById = ref.read(getCommunityByIdUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;

      if (token == null) {
        throw Exception('User not authenticated or token not found');
      }

      final community = await getCommunityById.execute(communityId, token: token);
      state = state.copyWith(selectedCommunity: community, loading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> createCommunity({
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    state = state.copyWith(processing: true, error: null);
    try {
      final createCommunity = ref.read(createCommunityUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;
      final userId = authState.user?.id;

      if (token == null || userId == null) {
        throw Exception('User not authenticated or token not found');
      }

  final ownerProfileId = userId; // TODO: replace with profile ID when available

      await createCommunity.execute(
        ownerId: userId,
        ownerProfileId: ownerProfileId,
        request: CreateCommunityRequest(
          name: name,
          description: description,
          imageUrl: imageUrl,
        ),
        token: token,
      );

      await fetchAllCommunities();
      await fetchCommunitiesByCreator(userId);
      state = state.copyWith(processing: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), processing: false);
    }
  }

  Future<void> updateCommunity({
    required String communityId,
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    state = state.copyWith(processing: true, error: null);
    try {
      final updateCommunity = ref.read(updateCommunityUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;

      if (token == null) {
        throw Exception('User not authenticated or token not found');
      }

      final community = await updateCommunity.execute(
        request: UpdateCommunityRequest(
          communityId: communityId,
          name: name,
          description: description,
          imageUrl: imageUrl,
        ),
        token: token,
      );

      state = state.copyWith(selectedCommunity: community, processing: false);
      await fetchAllCommunities();
    } catch (e) {
      state = state.copyWith(error: e.toString(), processing: false);
    }
  }

  Future<void> fetchCommunitiesByCreator(String creatorId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getCommunitiesByCreatorUseCaseProvider);
      final token = _requireToken();
      final communities = await useCase.execute(creatorId, token: token);
      state = state.copyWith(loading: false, creatorCommunities: communities);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> deleteCommunity(String communityId) async {
    state = state.copyWith(processing: true, error: null);
    try {
      final deleteCommunity = ref.read(deleteCommunityUseCaseProvider);
      final token = _requireToken();
      await deleteCommunity.execute(communityId, token: token);

      final shouldClearSelected = state.selectedCommunity?.id == communityId;
      state = state.copyWith(
        processing: false,
        communities: state.communities.where((c) => c.id != communityId).toList(),
        creatorCommunities: state.creatorCommunities.where((c) => c.id != communityId).toList(),
        selectedCommunity: shouldClearSelected ? null : state.selectedCommunity,
        overrideSelectedCommunity: shouldClearSelected,
      );
    } catch (e) {
      state = state.copyWith(processing: false, error: e.toString());
    }
  }

  String _requireToken() {
    final authState = ref.read(authControllerProvider);
    final token = authState.token ?? authState.user?.token;
    if (token == null) {
      throw Exception('User not authenticated or token not found');
    }
    return token;
  }
}
