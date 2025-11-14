import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onDelete;
  final bool showCommunity;

  const PostCard({
    super.key,
    required this.post,
    this.onTap,
    this.onLike,
    this.onDelete,
    this.showCommunity = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Author header
              _buildAuthorHeader(context),
              const SizedBox(height: 12),

              // Community badge (if showCommunity)
              if (showCommunity && post.community != null) ...[
                _buildCommunityBadge(context),
                const SizedBox(height: 12),
              ],

              // Post content
              Text(post.content, style: Theme.of(context).textTheme.bodyLarge),

              // Post image (if exists)
              if (post.imageUrl != null && post.imageUrl!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildPostImage(),
              ],

              const SizedBox(height: 12),

              // Actions (like, timestamp)
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthorHeader(BuildContext context) {
    final author = post.author;
    final displayName = author?.displayName ?? 'Unknown User';

    return Row(
      children: [
        // Author avatar
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              author?.avatarUrl != null && author!.avatarUrl!.isNotEmpty
              ? NetworkImage(author.avatarUrl!)
              : null,
          child: author?.avatarUrl == null || author!.avatarUrl!.isEmpty
              ? Icon(Icons.person, size: 20, color: Colors.grey[600])
              : null,
        ),
        const SizedBox(width: 12),

        // Author info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayName,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                _formatDate(post.createdAt),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
              ),
            ],
          ),
        ),

        // Delete button (if provided)
        if (onDelete != null)
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onDelete,
            color: Colors.grey[600],
          ),
      ],
    );
  }

  Widget _buildCommunityBadge(BuildContext context) {
    final community = post.community!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.groups, size: 16, color: Theme.of(context).primaryColor),
          const SizedBox(width: 4),
          Text(
            community.name,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        post.imageUrl!,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 200,
            color: Colors.grey[300],
            child: const Center(
              child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
            ),
          );
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 200,
            color: Colors.grey[200],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      children: [
        // Like button
        InkWell(
          onTap: onLike,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Icon(
                  post.viewerHasReacted
                      ? Icons.favorite
                      : Icons.favorite_border,
                  size: 20,
                  color: post.viewerHasReacted ? Colors.red : Colors.grey[600],
                ),
                if (post.reactionCount > 0) ...[
                  const SizedBox(width: 4),
                  Text(
                    post.reactionCount.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                  ),
                ],
              ],
            ),
          ),
        ),

        const Spacer(),

        // Updated indicator
        if (post.updatedAt != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Text(
              'edited',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey[500],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }
}
