import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/providers.dart';
import '../widgets/community_card.dart';

class CommunityPage extends ConsumerStatefulWidget {
  const CommunityPage({super.key});

  @override
  ConsumerState<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends ConsumerState<CommunityPage> {
  @override
  void initState() {
    super.initState();
    // Fetch communities when the page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(communityControllerProvider.notifier).fetchAllCommunities();
    });
  }

  @override
  Widget build(BuildContext context) {
    final communityState = ref.watch(communityControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(communityControllerProvider.notifier)
                  .fetchAllCommunities();
            },
          ),
        ],
      ),
      body: _buildBody(communityState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Navigate to create community page
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Create community - Coming soon')),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(communityState) {
    // Show loading indicator
    if (communityState.loading && communityState.communities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show error message
    if (communityState.error != null && communityState.communities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Error loading communities',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                communityState.error ?? 'Unknown error',
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ref
                    .read(communityControllerProvider.notifier)
                    .fetchAllCommunities();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (communityState.communities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.groups_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No communities yet',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to create one!',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    // Show communities list
    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(communityControllerProvider.notifier)
            .fetchAllCommunities();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: communityState.communities.length,
        padding: const EdgeInsets.only(top: 8, bottom: 80),
        itemBuilder: (context, index) {
          final community = communityState.communities[index];
          return CommunityCard(
            community: community,
            onTap: () {
              // TODO: Navigate to community detail page
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Open ${community.name}')));
            },
          );
        },
      ),
    );
  }
}
