// community/application/use_cases/get_user_feed_use_case.dart
import '../../domain/entities/feed_entry.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/requests/feed_requests.dart';

class GetUserFeedUseCase {
  final FeedRepository repo;

  GetUserFeedUseCase(this.repo);

  Future<List<FeedEntry>> execute(UserFeedQuery query, {required String token}) {
    return repo.getUserFeed(query, token: token);
  }
}
