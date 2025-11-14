// community/domain/requests/subscription_requests.dart
import 'pagination.dart';

class CreateSubscriptionRequest {
  final String communityId;

  const CreateSubscriptionRequest({required this.communityId});
}

class SubscriptionByUserQuery {
  final String userId;
  final PaginationQuery pagination;

  const SubscriptionByUserQuery({
    required this.userId,
    this.pagination = const PaginationQuery(),
  });
}
