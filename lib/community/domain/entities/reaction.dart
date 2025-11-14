// community/domain/entities/reaction.dart
import 'user_summary.dart';

enum ReactionType {
  like,
  love,
  clap,
  wow,
  laugh,
}

extension ReactionTypeMapper on ReactionType {
  static ReactionType fromString(String value) {
    return ReactionType.values.firstWhere(
      (type) => type.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ReactionType.like,
    );
  }

  String get value => name.toLowerCase();
}

class Reaction {
  final String id;
  final String userId;
  final String postId;
  final ReactionType type;
  final DateTime createdAt;
  final UserSummary? user;

  const Reaction({
    required this.id,
    required this.userId,
    required this.postId,
    required this.type,
    required this.createdAt,
    this.user,
  });
}
