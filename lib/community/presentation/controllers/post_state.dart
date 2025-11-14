// community/presentation/controllers/post_state.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/post.dart';

class PostState {
  final bool loading;
  final List<Post> allPosts;
  final List<Post> feedPosts;
  final List<Post> userPosts;
  final PaginatedResult<Post>? communityPosts;
  final String? communityIdForPage;
  final String? error;
  final bool processing;

  const PostState({
    this.loading = false,
    this.allPosts = const [],
    this.feedPosts = const [],
    this.userPosts = const [],
    this.communityPosts,
    this.communityIdForPage,
    this.error,
    this.processing = false,
  });

  PostState copyWith({
    bool? loading,
    List<Post>? allPosts,
    List<Post>? feedPosts,
    List<Post>? userPosts,
    PaginatedResult<Post>? communityPosts,
    String? communityIdForPage,
    String? error,
    bool? processing,
    bool overrideCommunityPosts = false,
    bool overrideCommunityIdForPage = false,
  }) {
    return PostState(
      loading: loading ?? this.loading,
      allPosts: allPosts ?? this.allPosts,
      feedPosts: feedPosts ?? this.feedPosts,
      userPosts: userPosts ?? this.userPosts,
      communityPosts: overrideCommunityPosts
          ? communityPosts
          : (communityPosts ?? this.communityPosts),
      communityIdForPage: overrideCommunityIdForPage
          ? communityIdForPage
          : (communityIdForPage ?? this.communityIdForPage),
      error: error,
      processing: processing ?? this.processing,
    );
  }
}
