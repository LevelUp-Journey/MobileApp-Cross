// community/presentation/controllers/subscription_state.dart
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/subscription.dart';

class SubscriptionState {
  final bool loading;
  final List<Subscription> communitySubscriptions;
  final PaginatedResult<Subscription>? userSubscriptions;
  final Subscription? activeSubscription;
  final String? error;

  const SubscriptionState({
    this.loading = false,
    this.communitySubscriptions = const [],
    this.userSubscriptions,
    this.activeSubscription,
    this.error,
  });

  SubscriptionState copyWith({
    bool? loading,
    List<Subscription>? communitySubscriptions,
    PaginatedResult<Subscription>? userSubscriptions,
    Subscription? activeSubscription,
    String? error,
    bool overrideUserSubscriptions = false,
    bool overrideActiveSubscription = false,
  }) {
    return SubscriptionState(
      loading: loading ?? this.loading,
      communitySubscriptions: communitySubscriptions ?? this.communitySubscriptions,
      userSubscriptions: overrideUserSubscriptions
          ? userSubscriptions
          : (userSubscriptions ?? this.userSubscriptions),
      activeSubscription: overrideActiveSubscription
          ? activeSubscription
          : (activeSubscription ?? this.activeSubscription),
      error: error,
    );
  }
}
