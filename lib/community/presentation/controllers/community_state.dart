// community/presentation/controllers/community_state.dart
import '../../domain/entities/community.dart';

class CommunityState {
  final bool loading;
  final List<Community> communities;
  final Community? selectedCommunity;
  final String? error;

  const CommunityState({
    this.loading = false,
    this.communities = const [],
    this.selectedCommunity,
    this.error,
  });

  CommunityState copyWith({
    bool? loading,
    List<Community>? communities,
    Community? selectedCommunity,
    String? error,
  }) =>
      CommunityState(
        loading: loading ?? this.loading,
        communities: communities ?? this.communities,
        selectedCommunity: selectedCommunity ?? this.selectedCommunity,
        error: error,
      );
}
