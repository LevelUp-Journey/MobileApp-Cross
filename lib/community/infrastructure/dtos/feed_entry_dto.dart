// community/infrastructure/dtos/feed_entry_dto.dart
import '../../domain/entities/feed_entry.dart';
import 'community_dto.dart';
import 'post_dto.dart';
import 'reaction_dto.dart';

class FeedEntryDto {
  final String id;
  final PostDto post;
  final CommunityDto community;
  final List<ReactionDto> reactions;
  final bool viewerHasReacted;

  const FeedEntryDto({
    required this.id,
    required this.post,
    required this.community,
    required this.reactions,
    required this.viewerHasReacted,
  });

  factory FeedEntryDto.fromJson(Map<String, dynamic> json) {
    final reactionsJson = json['reactions'] as List<dynamic>? ?? const [];
    return FeedEntryDto(
      id: json['id']?.toString() ?? '',
      post: PostDto.fromJson(json['post'] as Map<String, dynamic>),
      community: CommunityDto.fromJson(json['community'] as Map<String, dynamic>),
      reactions: reactionsJson
          .map((reaction) => ReactionDto.fromJson(reaction as Map<String, dynamic>))
          .toList(),
      viewerHasReacted: json['viewerHasReacted'] == true,
    );
  }

  FeedEntry toDomain() => FeedEntry(
        id: id,
        post: post.toDomain(),
        community: community.toDomain(),
        aggregatedReactions: reactions.map((reaction) => reaction.toDomain()).toList(),
        viewerHasReacted: viewerHasReacted,
      );
}
