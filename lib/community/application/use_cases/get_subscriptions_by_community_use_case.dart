// community/application/use_cases/get_subscriptions_by_community_use_case.dart
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

class GetSubscriptionsByCommunityUseCase {
  final SubscriptionRepository repo;

  GetSubscriptionsByCommunityUseCase(this.repo);

  Future<List<Subscription>> execute(String communityId, {required String token}) {
    return repo.getSubscriptionsByCommunity(communityId, token: token);
  }
}
