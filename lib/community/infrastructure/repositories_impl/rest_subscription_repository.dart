// community/infrastructure/repositories_impl/rest_subscription_repository.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/requests/pagination.dart';
import '../../domain/requests/subscription_requests.dart';
import '../datasources/subscription_remote_data_source.dart';

class RestSubscriptionRepository implements SubscriptionRepository {
  final SubscriptionRemoteDataSource _remote;

  RestSubscriptionRepository(this._remote);

  @override
  Future<Subscription> createSubscription({
    required String userId,
    required CreateSubscriptionRequest request,
    required String token,
  }) async {
    final dto = await _remote.createSubscription(
      token: token,
      request: request,
    );
    return dto.toDomain();
  }

  @override
  Future<bool> deleteSubscription(
    String subscriptionId, {
    required String token,
  }) {
    return _remote.deleteSubscription(subscriptionId, token);
  }

  @override
  Future<List<Subscription>> getSubscriptionsByCommunity(
    String communityId, {
    required String token,
  }) async {
    final dtos = await _remote.getSubscriptionsByCommunity(communityId, token);
    return dtos.map((dto) => dto.toDomain()).toList();
  }

  @override
  Future<PaginatedResult<Subscription>> getSubscriptionsByUser(
    SubscriptionByUserQuery query, {
    required String token,
  }) async {
    final dto = await _remote.getSubscriptionsByUser(query, token);
    final subscriptions = dto.items.map((item) => item.toDomain()).toList();
    return dto.toDomain(subscriptions);
  }

  @override
  Future<Subscription?> getUserSubscriptionForCommunity({
    required String communityId,
    required String userId,
    required String token,
  }) async {
    final result = await getSubscriptionsByUser(
      SubscriptionByUserQuery(
        userId: userId,
        pagination: const PaginationQuery(page: 0, size: 100),
      ),
      token: token,
    );
    for (final subscription in result.items) {
      if (subscription.communityId == communityId) {
        return subscription;
      }
    }
    return null;
  }
}
