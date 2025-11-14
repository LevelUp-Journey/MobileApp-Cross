// community/application/use_cases/get_subscriptions_by_user_use_case.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/requests/subscription_requests.dart';

class GetSubscriptionsByUserUseCase {
  final SubscriptionRepository repo;

  GetSubscriptionsByUserUseCase(this.repo);

  Future<PaginatedResult<Subscription>> execute(
    SubscriptionByUserQuery query, {
    required String token,
  }) {
    return repo.getSubscriptionsByUser(query, token: token);
  }
}
