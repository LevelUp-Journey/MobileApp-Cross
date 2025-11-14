// community/infrastructure/dtos/reaction_dto.dart
import '../../domain/entities/reaction.dart';
import 'user_summary_dto.dart';

class ReactionDto {
  final String id;
  final String userId;
  final String postId;
  final ReactionType type;
  final DateTime createdAt;
  final UserSummaryDto? user;

  const ReactionDto({
    required this.id,
    required this.userId,
    required this.postId,
    required this.type,
    required this.createdAt,
    this.user,
  });

  factory ReactionDto.fromJson(Map<String, dynamic> json) {
    return ReactionDto(
      id: json['id']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      postId: json['postId']?.toString() ?? '',
      type: ReactionTypeMapper.fromString(json['type']?.toString() ?? 'like'),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      user: json['user'] == null
          ? null
          : UserSummaryDto.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Reaction toDomain() => Reaction(
        id: id,
        userId: userId,
        postId: postId,
        type: type,
        createdAt: createdAt,
        user: user?.toDomain(),
      );
}
