// community/domain/entities/subscription.dart
import 'community.dart';
import 'user_summary.dart';

class Subscription {
  final String id;
  final String userId;
  final String communityId;
  final DateTime createdAt;
  final Community? community;
  final UserSummary? user;

  const Subscription({
    required this.id,
    required this.userId,
    required this.communityId,
    required this.createdAt,
    this.community,
    this.user,
  });
}
