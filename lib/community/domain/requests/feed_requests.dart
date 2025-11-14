// community/domain/requests/feed_requests.dart
import 'pagination.dart';

class UserFeedQuery {
  final String userId;
  final OffsetQuery offsetQuery;

  const UserFeedQuery({
    required this.userId,
    this.offsetQuery = const OffsetQuery(),
  });
}
