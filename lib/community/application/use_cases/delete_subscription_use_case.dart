// community/application/use_cases/delete_subscription_use_case.dart
import '../../domain/repositories/subscription_repository.dart';

class DeleteSubscriptionUseCase {
  final SubscriptionRepository repo;

  DeleteSubscriptionUseCase(this.repo);

  Future<bool> execute(String subscriptionId, {required String token}) {
    return repo.deleteSubscription(subscriptionId, token: token);
  }
}
