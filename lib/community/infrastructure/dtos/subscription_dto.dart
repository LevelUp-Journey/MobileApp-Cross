// community/infrastructure/dtos/subscription_dto.dart
import '../../domain/entities/subscription.dart';
import 'community_dto.dart';
import 'user_summary_dto.dart';

class SubscriptionDto {
  final String id;
  final String userId;
  final String communityId;
  final DateTime createdAt;
  final CommunityDto? community;
  final UserSummaryDto? user;

  const SubscriptionDto({
    required this.id,
    required this.userId,
    required this.communityId,
    required this.createdAt,
    this.community,
    this.user,
  });

  factory SubscriptionDto.fromJson(Map<String, dynamic> json) {
    return SubscriptionDto(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      communityId: json['communityId']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      community: json['community'] == null
          ? null
          : CommunityDto.fromJson(json['community'] as Map<String, dynamic>),
      user: json['user'] == null
          ? null
          : UserSummaryDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Subscription toDomain() => Subscription(
        id: id,
        userId: userId,
        communityId: communityId,
        createdAt: createdAt,
        community: community?.toDomain(),
        user: user?.toDomain(),
      );
}
