// community/domain/requests/post_requests.dart
import '../requests/pagination.dart';

class CreatePostRequest {
  final String communityId;
  final String content;
  final String? imageUrl;

  const CreatePostRequest({
    required this.communityId,
    required this.content,
    this.imageUrl,
  });
}

class CommunityPostsQuery {
  final String communityId;
  final PaginationQuery pagination;

  const CommunityPostsQuery({
    required this.communityId,
    this.pagination = const PaginationQuery(),
  });
}

class FeedPostsQuery {
  final String userId;
  final OffsetQuery offsetQuery;

  const FeedPostsQuery({
    required this.userId,
    this.offsetQuery = const OffsetQuery(),
  });
}
