// community/domain/entities/post.dart
import 'community.dart';
import 'user_summary.dart';

class Post {
  final String id;
  final String communityId;
  final String authorId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int reactionCount;
  final bool viewerHasReacted;
  final UserSummary? author;
  final Community? community;

  const Post({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    this.reactionCount = 0,
    this.viewerHasReacted = false,
    this.author,
    this.community,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Post && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
