// community/domain/entities/feed_entry.dart
import 'community.dart';
import 'post.dart';
import 'reaction.dart';

class FeedEntry {
  final String id;
  final Post post;
  final Community community;
  final List<Reaction> aggregatedReactions;
  final bool viewerHasReacted;

  const FeedEntry({
    required this.id,
    required this.post,
    required this.community,
    this.aggregatedReactions = const [],
    this.viewerHasReacted = false,
  });
}
