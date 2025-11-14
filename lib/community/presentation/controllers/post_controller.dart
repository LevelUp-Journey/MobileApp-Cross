// community/presentation/controllers/post_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/create_post_use_case.dart';
import '../../application/use_cases/delete_post_use_case.dart';
import '../../application/use_cases/get_all_posts_use_case.dart';
import '../../application/use_cases/get_feed_posts_use_case.dart';
import '../../application/use_cases/get_posts_by_community_use_case.dart';
import '../../application/use_cases/get_posts_by_user_use_case.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/post.dart';
import '../../domain/requests/pagination.dart';
import '../../domain/requests/post_requests.dart';
import 'post_state.dart';
import 'providers.dart';

class PostController extends Notifier<PostState> {
  @override
  PostState build() => const PostState();

  Future<void> fetchAllPosts() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getAllPostsUseCaseProvider);
      final token = _requireToken();
      final posts = await useCase.execute(token: token);
      state = state.copyWith(loading: false, allPosts: posts);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> fetchCommunityPosts(
    String communityId, {
    PaginationQuery pagination = const PaginationQuery(),
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getPostsByCommunityUseCaseProvider);
      final token = _requireToken();
      final query = CommunityPostsQuery(communityId: communityId, pagination: pagination);
      final page = await useCase.execute(query, token: token);
      state = state.copyWith(
        loading: false,
        communityPosts: page,
        communityIdForPage: communityId,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> fetchPostsByUser(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getPostsByUserUseCaseProvider);
      final token = _requireToken();
      final posts = await useCase.execute(userId, token: token);
      state = state.copyWith(loading: false, userPosts: posts);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> fetchFeedPosts(String userId, {OffsetQuery offset = const OffsetQuery()}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getFeedPostsUseCaseProvider);
      final token = _requireToken();
      final posts = await useCase.execute(FeedPostsQuery(userId: userId, offsetQuery: offset), token: token);
      state = state.copyWith(loading: false, feedPosts: posts);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<Post?> createPost(CreatePostRequest request) async {
    state = state.copyWith(processing: true, error: null);
    try {
      final useCase = ref.read(createPostUseCaseProvider);
      final token = _requireToken();
      final authorId = _requireUserId();
      final post = await useCase.execute(authorId: authorId, request: request, token: token);

      final updatedAllPosts = <Post>[post, ...state.allPosts];
      state = state.copyWith(processing: false, allPosts: updatedAllPosts);

      if (state.communityIdForPage == post.communityId && state.communityPosts != null) {
        final existing = state.communityPosts!;
        final updatedItems = <Post>[post, ...existing.items];
        state = state.copyWith(
          communityPosts: PaginatedResult<Post>(
            items: updatedItems,
            page: existing.page,
            size: existing.size,
            totalElements: existing.totalElements + 1,
            hasNext: existing.hasNext,
            hasPrevious: existing.hasPrevious,
          ),
        );
      }
      return post;
    } catch (error) {
      state = state.copyWith(processing: false, error: error.toString());
      return null;
    }
  }

  Future<void> deletePost(String postId) async {
    state = state.copyWith(processing: true, error: null);
    try {
      final useCase = ref.read(deletePostUseCaseProvider);
      final token = _requireToken();
      await useCase.execute(postId, token: token);

      final updatedCommunityPage = _removePostFromCommunityPage(postId);

      state = state.copyWith(
        processing: false,
        allPosts: state.allPosts.where((post) => post.id != postId).toList(),
        userPosts: state.userPosts.where((post) => post.id != postId).toList(),
        feedPosts: state.feedPosts.where((post) => post.id != postId).toList(),
        communityPosts: updatedCommunityPage,
        overrideCommunityPosts: true,
      );
    } catch (error) {
      state = state.copyWith(processing: false, error: error.toString());
    }
  }

  String _requireToken() {
    final authState = ref.read(authControllerProvider);
    final token = authState.token ?? authState.user?.token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }

  String _requireUserId() {
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id;
    if (userId == null) throw Exception('User not authenticated');
    return userId;
  }

  PaginatedResult<Post>? _removePostFromCommunityPage(String postId) {
    final current = state.communityPosts;
    if (current == null) return null;
    final filtered = current.items.where((post) => post.id != postId).toList();
    if (filtered.length == current.items.length) {
      return current;
    }
    final total = current.totalElements > 0 ? current.totalElements - 1 : 0;
    return PaginatedResult<Post>(
      items: filtered,
      page: current.page,
      size: current.size,
      totalElements: total,
      hasNext: current.hasNext,
      hasPrevious: current.hasPrevious,
    );
  }
}
