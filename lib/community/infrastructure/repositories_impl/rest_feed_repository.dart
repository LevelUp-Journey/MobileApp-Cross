// community/infrastructure/repositories_impl/rest_feed_repository.dart
import '../../domain/entities/feed_entry.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/requests/feed_requests.dart';
import '../datasources/feed_remote_data_source.dart';

class RestFeedRepository implements FeedRepository {
  final FeedRemoteDataSource _remote;

  RestFeedRepository(this._remote);

  @override
  Future<List<FeedEntry>> getUserFeed(UserFeedQuery query, {required String token}) async {
    final dtos = await _remote.getUserFeed(query, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }
}
