// community/presentation/controllers/subscription_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../iam/presentation/controllers/providers.dart';
import '../../application/use_cases/create_subscription_use_case.dart';
import '../../application/use_cases/delete_subscription_use_case.dart';
import '../../application/use_cases/get_subscriptions_by_community_use_case.dart';
import '../../application/use_cases/get_subscriptions_by_user_use_case.dart';
import '../../application/use_cases/get_user_subscription_for_community_use_case.dart';
import '../../domain/entities/paginated_result.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/requests/pagination.dart';
import '../../domain/requests/subscription_requests.dart';
import 'providers.dart';
import 'subscription_state.dart';

class SubscriptionController extends Notifier<SubscriptionState> {
  @override
  SubscriptionState build() => const SubscriptionState();

  Future<void> fetchCommunitySubscriptions(String communityId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getSubscriptionsByCommunityUseCaseProvider);
      final token = _requireToken();
      final subscriptions = await useCase.execute(communityId, token: token);
      state = state.copyWith(loading: false, communitySubscriptions: subscriptions);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<void> fetchUserSubscriptions({PaginationQuery pagination = const PaginationQuery()}) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getSubscriptionsByUserUseCaseProvider);
      final token = _requireToken();
      final userId = _requireUserId();
      final page = await useCase.execute(
        SubscriptionByUserQuery(userId: userId, pagination: pagination),
        token: token,
      );
      state = state.copyWith(loading: false, userSubscriptions: page);
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  Future<Subscription?> createSubscription(String communityId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(createSubscriptionUseCaseProvider);
      final token = _requireToken();
      final userId = _requireUserId();
      final subscription = await useCase.execute(
        userId: userId,
        request: CreateSubscriptionRequest(communityId: communityId),
        token: token,
      );
      state = state.copyWith(
        loading: false,
        activeSubscription: subscription,
        communitySubscriptions: [subscription, ...state.communitySubscriptions],
      );
      return subscription;
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
      return null;
    }
  }

  Future<bool> deleteSubscription(String subscriptionId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(deleteSubscriptionUseCaseProvider);
      final token = _requireToken();
      final deleted = await useCase.execute(subscriptionId, token: token);
      if (deleted) {
        state = state.copyWith(
          communitySubscriptions: state.communitySubscriptions
              .where((sub) => sub.id != subscriptionId)
              .toList(),
          activeSubscription: state.activeSubscription?.id == subscriptionId
              ? null
              : state.activeSubscription,
          userSubscriptions: state.userSubscriptions == null
              ? state.userSubscriptions
              : PaginationResultHelper.removeSubscription(state.userSubscriptions!, subscriptionId),
          overrideActiveSubscription: state.activeSubscription?.id == subscriptionId,
          overrideUserSubscriptions: state.userSubscriptions != null,
        );
      }
      state = state.copyWith(loading: false);
      return deleted;
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
      return false;
    }
  }

  Future<void> checkUserSubscriptionForCommunity(String communityId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final useCase = ref.read(getUserSubscriptionForCommunityUseCaseProvider);
      final token = _requireToken();
      final userId = _requireUserId();
      final subscription = await useCase.execute(
        communityId: communityId,
        userId: userId,
        token: token,
      );
      state = state.copyWith(
        loading: false,
        activeSubscription: subscription,
        overrideActiveSubscription: true,
      );
    } catch (error) {
      state = state.copyWith(loading: false, error: error.toString());
    }
  }

  String _requireToken() {
    final authState = ref.read(authControllerProvider);
    final token = authState.token ?? authState.user?.token;
    if (token == null) throw Exception('User not authenticated');
    return token;
  }

  String _requireUserId() {
    final authState = ref.read(authControllerProvider);
    final userId = authState.user?.id;
    if (userId == null) throw Exception('User not authenticated');
    return userId;
  }
}

class PaginationResultHelper {
  static PaginatedResult<Subscription> removeSubscription(
    PaginatedResult<Subscription> source,
    String subscriptionId,
  ) {
    final filtered = source.items.where((sub) => sub.id != subscriptionId).toList();
    final total = source.totalElements > 0 ? source.totalElements - 1 : 0;
    return PaginatedResult<Subscription>(
      items: filtered,
      page: source.page,
      size: source.size,
      totalElements: total,
      hasNext: source.hasNext,
      hasPrevious: source.hasPrevious,
    );
  }
}
