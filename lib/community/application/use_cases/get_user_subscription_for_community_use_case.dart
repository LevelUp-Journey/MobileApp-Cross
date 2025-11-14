// community/application/use_cases/get_user_subscription_for_community_use_case.dart
import '../../domain/entities/subscription.dart';
import '../../domain/repositories/subscription_repository.dart';

class GetUserSubscriptionForCommunityUseCase {
  final SubscriptionRepository repo;

  GetUserSubscriptionForCommunityUseCase(this.repo);

  Future<Subscription?> execute({
    required String communityId,
    required String userId,
    required String token,
  }) {
    return repo.getUserSubscriptionForCommunity(
      communityId: communityId,
      userId: userId,
      token: token,
    );
  }
}
