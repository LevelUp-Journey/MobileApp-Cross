// community/domain/repositories/subscription_repository.dart
import '../entities/paginated_result.dart';
import '../entities/subscription.dart';
import '../requests/subscription_requests.dart';

abstract class SubscriptionRepository {
  Future<Subscription> createSubscription({
    required String userId,
    required CreateSubscriptionRequest request,
    required String token,
  });
  Future<bool> deleteSubscription(String subscriptionId, {required String token});
  Future<List<Subscription>> getSubscriptionsByCommunity(String communityId, {required String token});
  Future<PaginatedResult<Subscription>> getSubscriptionsByUser(SubscriptionByUserQuery query, {required String token});
  Future<Subscription?> getUserSubscriptionForCommunity({
    required String communityId,
    required String userId,
    required String token,
  });
}
