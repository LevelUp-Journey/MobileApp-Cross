// community/presentation/controllers/community_state.dart
import '../../domain/entities/community.dart';

class CommunityState {
  final bool loading;
  final List<Community> communities;
  final List<Community> creatorCommunities;
  final Community? selectedCommunity;
  final String? error;
  final bool processing;

  const CommunityState({
    this.loading = false,
    this.communities = const [],
    this.creatorCommunities = const [],
    this.selectedCommunity,
    this.error,
    this.processing = false,
  });

  CommunityState copyWith({
    bool? loading,
    List<Community>? communities,
    List<Community>? creatorCommunities,
    Community? selectedCommunity,
    bool overrideSelectedCommunity = false,
    String? error,
    bool? processing,
  }) =>
      CommunityState(
        loading: loading ?? this.loading,
        communities: communities ?? this.communities,
        creatorCommunities: creatorCommunities ?? this.creatorCommunities,
        selectedCommunity: overrideSelectedCommunity
            ? selectedCommunity
            : (selectedCommunity ?? this.selectedCommunity),
        error: error,
        processing: processing ?? this.processing,
      );
}
