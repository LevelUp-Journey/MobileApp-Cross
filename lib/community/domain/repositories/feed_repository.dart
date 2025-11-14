// community/domain/repositories/feed_repository.dart
import '../entities/feed_entry.dart';
import '../requests/feed_requests.dart';

abstract class FeedRepository {
  Future<List<FeedEntry>> getUserFeed(UserFeedQuery query, {required String token});
}
