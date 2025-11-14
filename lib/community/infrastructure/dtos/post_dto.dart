// community/infrastructure/dtos/post_dto.dart
import '../../domain/entities/post.dart';
import 'community_dto.dart';
import 'user_summary_dto.dart';

class PostDto {
  final String id;
  final String communityId;
  final String authorId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int reactionCount;
  final bool viewerHasReacted;
  final UserSummaryDto? author;
  final CommunityDto? community;

  const PostDto({
    required this.id,
    required this.communityId,
    required this.authorId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    this.updatedAt,
    required this.reactionCount,
    required this.viewerHasReacted,
    this.author,
    this.community,
  });

  factory PostDto.fromJson(Map<String, dynamic> json) {
    final authorJson = json['author'] as Map<String, dynamic>?;
    final communityJson = json['community'] as Map<String, dynamic>?;
    return PostDto(
      id: json['id']?.toString() ?? '',
      communityId: json['communityId']?.toString() ?? '',
      authorId: json['authorId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      updatedAt: json['updatedAt'] != null ? DateTime.tryParse(json['updatedAt'].toString()) : null,
      reactionCount: json['reactionCount'] == null ? 0 : int.tryParse(json['reactionCount'].toString()) ?? 0,
      viewerHasReacted: json['viewerHasReacted'] == true,
      author: authorJson == null ? null : UserSummaryDto.fromJson(authorJson),
      community: communityJson == null ? null : CommunityDto.fromJson(communityJson),
    );
  }

  Post toDomain() => Post(
        id: id,
        communityId: communityId,
        authorId: authorId,
        content: content,
        imageUrl: imageUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
        reactionCount: reactionCount,
        viewerHasReacted: viewerHasReacted,
        author: author?.toDomain(),
        community: community?.toDomain(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'communityId': communityId,
        'authorId': authorId,
        'content': content,
        'createdAt': createdAt.toIso8601String(),
        if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
        if (imageUrl != null) 'imageUrl': imageUrl,
        'reactionCount': reactionCount,
        'viewerHasReacted': viewerHasReacted,
        if (author != null) 'author': author!.toJson(),
        if (community != null) 'community': community!.toJson(),
      };
}
