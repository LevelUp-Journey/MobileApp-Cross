// community/application/use_cases/create_subscription_use_case.dart
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../domain/requests/subscription_requests.dart';

class CreateSubscriptionUseCase {
  final SubscriptionRepository repo;

  CreateSubscriptionUseCase(this.repo);

  Future<Subscription> execute({
    required String userId,
    required CreateSubscriptionRequest request,
    required String token,
  }) {
    return repo.createSubscription(userId: userId, request: request, token: token);
  }
}
