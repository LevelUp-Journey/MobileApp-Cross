import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/community.dart';
import '../../domain/requests/pagination.dart';
import '../controllers/providers.dart';
import '../widgets/post_card.dart';

class CommunityDetailPage extends ConsumerStatefulWidget {
  final Community community;

  const CommunityDetailPage({super.key, required this.community});

  @override
  ConsumerState<CommunityDetailPage> createState() =>
      _CommunityDetailPageState();
}

class _CommunityDetailPageState extends ConsumerState<CommunityDetailPage> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 20;

  @override
  void initState() {
    super.initState();
    // Fetch posts and check subscription when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchPosts();
      ref
          .read(subscriptionControllerProvider.notifier)
          .checkUserSubscriptionForCommunity(widget.community.id);
    });

    // Setup infinite scroll
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _fetchPosts({bool loadMore = false}) {
    if (loadMore) {
      _currentPage++;
    } else {
      _currentPage = 0;
    }

    ref
        .read(postControllerProvider.notifier)
        .fetchCommunityPosts(
          widget.community.id,
          pagination: PaginationQuery(page: _currentPage, size: _pageSize),
        );
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      final postState = ref.read(postControllerProvider);
      if (!postState.loading &&
          postState.communityPosts != null &&
          postState.communityPosts!.hasNext) {
        _fetchPosts(loadMore: true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(postControllerProvider);
    final subscriptionState = ref.watch(subscriptionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.community.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _fetchPosts(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Community header
          _buildCommunityHeader(context, subscriptionState),
          const Divider(height: 1),

          // Posts list
          Expanded(child: _buildPostsList(postState)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create post page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create post - Coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCommunityHeader(BuildContext context, subscriptionState) {
    final isSubscribed = subscriptionState.activeSubscription != null;

    return Container(
      padding: const EdgeInsets.all(16),
      color: Theme.of(context).primaryColor.withOpacity(0.05),
      child: Column(
        children: [
          Row(
            children: [
              // Community image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                    widget.community.imageUrl != null &&
                        widget.community.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          widget.community.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.groups,
                              size: 40,
                              color: Colors.grey[600],
                            );
                          },
                        ),
                      )
                    : Icon(Icons.groups, size: 40, color: Colors.grey[600]),
              ),
              const SizedBox(width: 16),

              // Community info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.community.name,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.community.description,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    if (widget.community.followerCount != null)
                      Row(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${widget.community.followerCount} ${widget.community.followerCount == 1 ? 'follower' : 'followers'}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Subscribe button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: subscriptionState.loading
                  ? null
                  : () => _toggleSubscription(isSubscribed, subscriptionState),
              icon: Icon(
                isSubscribed ? Icons.check_circle : Icons.add_circle_outline,
                size: 20,
              ),
              label: Text(isSubscribed ? 'Subscribed' : 'Subscribe'),
              style: ElevatedButton.styleFrom(
                backgroundColor: isSubscribed
                    ? Theme.of(context).colorScheme.surfaceVariant
                    : Theme.of(context).primaryColor,
                foregroundColor: isSubscribed
                    ? Theme.of(context).colorScheme.onSurfaceVariant
                    : Colors.white,
                elevation: isSubscribed ? 0 : 2,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: isSubscribed
                      ? BorderSide(color: Theme.of(context).colorScheme.outline)
                      : BorderSide.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleSubscription(bool isSubscribed, subscriptionState) async {
    if (isSubscribed) {
      final subscriptionId = subscriptionState.activeSubscription?.id;
      if (subscriptionId != null) {
        final success = await ref
            .read(subscriptionControllerProvider.notifier)
            .deleteSubscription(subscriptionId);
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unsubscribed successfully')),
          );
        }
      }
    } else {
      final subscription = await ref
          .read(subscriptionControllerProvider.notifier)
          .createSubscription(widget.community.id);
      if (subscription != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Subscribed successfully!')),
        );
      }
    }
  }

  Future<void> _toggleLike(post) async {
    final wasLiked = post.viewerHasReacted;

    // Optimistically update the UI
    ref
        .read(postControllerProvider.notifier)
        .updatePostReaction(post.id, isLiked: !wasLiked);

    try {
      if (wasLiked) {
        // Unlike
        await ref
            .read(reactionControllerProvider.notifier)
            .deleteReaction(post.id);
      } else {
        // Like
        await ref
            .read(reactionControllerProvider.notifier)
            .addReaction(post.id);
      }
    } catch (e) {
      // Revert on error
      if (mounted) {
        ref
            .read(postControllerProvider.notifier)
            .updatePostReaction(post.id, isLiked: wasLiked);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to ${wasLiked ? 'unlike' : 'like'} post'),
          ),
        );
      }
    }
  }

  Widget _buildPostsList(postState) {
    // Show loading indicator on initial load
    if (postState.loading &&
        (postState.communityPosts == null ||
            postState.communityPosts!.items.isEmpty)) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error message
    if (postState.error != null &&
        (postState.communityPosts == null ||
            postState.communityPosts!.items.isEmpty)) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading posts',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                postState.error ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _fetchPosts(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final posts = postState.communityPosts?.items ?? [];

    // Show empty state
    if (posts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.article_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('No posts yet', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Be the first to post in this community!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Show posts list
    return RefreshIndicator(
      onRefresh: () async {
        _fetchPosts();
      },
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount:
            posts.length + (postState.communityPosts?.hasNext == true ? 1 : 0),
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemBuilder: (context, index) {
          // Show loading indicator at the bottom when loading more
          if (index == posts.length) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          final post = posts[index];
          return PostCard(
            post: post,
            onTap: () {
              // TODO: Navigate to post detail or comments
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Post detail - Coming soon')),
              );
            },
            onLike: () => _toggleLike(post),
          );
        },
      ),
    );
  }
}
