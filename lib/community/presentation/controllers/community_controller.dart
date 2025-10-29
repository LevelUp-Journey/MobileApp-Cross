// community/presentation/controllers/community_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../domain/entities/community.dart';
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
      state = CommunityState(communities: communities);
    } catch (e) {
      state = CommunityState(error: e.toString());
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
    state = state.copyWith(loading: true, error: null);
    try {
      final createCommunity = ref.read(createCommunityUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;
      final userId = authState.user?.id;

      if (token == null || userId == null) {
        throw Exception('User not authenticated or token not found');
      }

      // TODO: Get ownerProfileId from profile service
      final ownerProfileId = userId; // Temporary, should be profile ID

      final community = await createCommunity.execute(
        ownerId: userId,
        ownerProfileId: ownerProfileId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        token: token,
      );

      // Refresh communities list
      await fetchAllCommunities();
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }

  Future<void> updateCommunity({
    required String communityId,
    required String name,
    required String description,
    String? imageUrl,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final updateCommunity = ref.read(updateCommunityUseCaseProvider);
      final authState = ref.read(authControllerProvider);
      final token = authState.token ?? authState.user?.token;

      if (token == null) {
        throw Exception('User not authenticated or token not found');
      }

      final community = await updateCommunity.execute(
        communityId: communityId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        token: token,
      );

      state = state.copyWith(selectedCommunity: community, loading: false);

      // Refresh communities list
      await fetchAllCommunities();
    } catch (e) {
      state = state.copyWith(error: e.toString(), loading: false);
    }
  }
}
