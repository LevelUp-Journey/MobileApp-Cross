// community/presentation/controllers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../application/use_cases/create_community_use_case.dart';
import '../../application/use_cases/create_post_use_case.dart';
import '../../application/use_cases/create_reaction_use_case.dart';
import '../../application/use_cases/create_subscription_use_case.dart';
import '../../application/use_cases/delete_community_use_case.dart';
import '../../application/use_cases/delete_post_use_case.dart';
import '../../application/use_cases/delete_reaction_use_case.dart';
import '../../application/use_cases/delete_subscription_use_case.dart';
import '../../application/use_cases/get_all_communities_use_case.dart';
import '../../application/use_cases/get_all_posts_use_case.dart';
import '../../application/use_cases/get_communities_by_creator_use_case.dart';
import '../../application/use_cases/get_community_by_id_use_case.dart';
import '../../application/use_cases/get_feed_posts_use_case.dart';
import '../../application/use_cases/get_posts_by_community_use_case.dart';
import '../../application/use_cases/get_posts_by_user_use_case.dart';
import '../../application/use_cases/get_reactions_by_post_use_case.dart';
import '../../application/use_cases/get_subscriptions_by_community_use_case.dart';
import '../../application/use_cases/get_subscriptions_by_user_use_case.dart';
import '../../application/use_cases/get_user_feed_use_case.dart';
import '../../application/use_cases/get_user_subscription_for_community_use_case.dart';
import '../../application/use_cases/update_community_use_case.dart';
import '../../domain/repositories/community_repository.dart';
import '../../domain/repositories/feed_repository.dart';
import '../../domain/repositories/post_repository.dart';
import '../../domain/repositories/reaction_repository.dart';
import '../../domain/repositories/subscription_repository.dart';
import '../../infrastructure/datasources/community_remote_data_source.dart';
import '../../infrastructure/datasources/feed_remote_data_source.dart';
import '../../infrastructure/datasources/post_remote_data_source.dart';
import '../../infrastructure/datasources/reaction_remote_data_source.dart';
import '../../infrastructure/datasources/subscription_remote_data_source.dart';
import '../../infrastructure/repositories_impl/rest_community_repository.dart';
import '../../infrastructure/repositories_impl/rest_feed_repository.dart';
import '../../infrastructure/repositories_impl/rest_post_repository.dart';
import '../../infrastructure/repositories_impl/rest_reaction_repository.dart';
import '../../infrastructure/repositories_impl/rest_subscription_repository.dart';
import 'community_controller.dart';
import 'community_state.dart';
import 'feed_controller.dart';
import 'feed_state.dart';
import 'post_controller.dart';
import 'post_state.dart';
import 'reaction_controller.dart';
import 'reaction_state.dart';
import 'subscription_controller.dart';
import 'subscription_state.dart';

// Shared providers
final httpClientProvider = Provider<http.Client>((ref) => http.Client());
final communityBaseUrlProvider = Provider<String>((ref) => Environment.communityserverBaseUrl);

// Remote data sources
final communityRemoteDataSourceProvider = Provider<CommunityRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(communityBaseUrlProvider);
  return CommunityRemoteDataSource(client, baseUrl: baseUrl);
});

final postRemoteDataSourceProvider = Provider<PostRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(communityBaseUrlProvider);
  return PostRemoteDataSource(client, baseUrl: baseUrl);
});

final feedRemoteDataSourceProvider = Provider<FeedRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(communityBaseUrlProvider);
  return FeedRemoteDataSource(client, baseUrl: baseUrl);
});

final reactionRemoteDataSourceProvider = Provider<ReactionRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(communityBaseUrlProvider);
  return ReactionRemoteDataSource(client, baseUrl: baseUrl);
});

final subscriptionRemoteDataSourceProvider = Provider<SubscriptionRemoteDataSource>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(communityBaseUrlProvider);
  return SubscriptionRemoteDataSource(client, baseUrl: baseUrl);
});

// Repositories
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final remote = ref.watch(communityRemoteDataSourceProvider);
  return RestCommunityRepository(remote);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remote = ref.watch(postRemoteDataSourceProvider);
  return RestPostRepository(remote);
});

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final remote = ref.watch(feedRemoteDataSourceProvider);
  return RestFeedRepository(remote);
});

final reactionRepositoryProvider = Provider<ReactionRepository>((ref) {
  final remote = ref.watch(reactionRemoteDataSourceProvider);
  return RestReactionRepository(remote);
});

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  final remote = ref.watch(subscriptionRemoteDataSourceProvider);
  return RestSubscriptionRepository(remote);
});

// Community use cases
final getAllCommunitiesUseCaseProvider = Provider<GetAllCommunitiesUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return GetAllCommunitiesUseCase(repo);
});

final getCommunityByIdUseCaseProvider = Provider<GetCommunityByIdUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return GetCommunityByIdUseCase(repo);
});

final getCommunitiesByCreatorUseCaseProvider = Provider<GetCommunitiesByCreatorUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return GetCommunitiesByCreatorUseCase(repo);
});

final createCommunityUseCaseProvider = Provider<CreateCommunityUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return CreateCommunityUseCase(repo);
});

final updateCommunityUseCaseProvider = Provider<UpdateCommunityUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return UpdateCommunityUseCase(repo);
});

final deleteCommunityUseCaseProvider = Provider<DeleteCommunityUseCase>((ref) {
  final repo = ref.watch(communityRepositoryProvider);
  return DeleteCommunityUseCase(repo);
});

// Post use cases
final getAllPostsUseCaseProvider = Provider<GetAllPostsUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return GetAllPostsUseCase(repo);
});

final getPostsByCommunityUseCaseProvider = Provider<GetPostsByCommunityUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return GetPostsByCommunityUseCase(repo);
});

final getPostsByUserUseCaseProvider = Provider<GetPostsByUserUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return GetPostsByUserUseCase(repo);
});

final getFeedPostsUseCaseProvider = Provider<GetFeedPostsUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return GetFeedPostsUseCase(repo);
});

final createPostUseCaseProvider = Provider<CreatePostUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return CreatePostUseCase(repo);
});

final deletePostUseCaseProvider = Provider<DeletePostUseCase>((ref) {
  final repo = ref.watch(postRepositoryProvider);
  return DeletePostUseCase(repo);
});

// Feed use cases
final getUserFeedUseCaseProvider = Provider<GetUserFeedUseCase>((ref) {
  final repo = ref.watch(feedRepositoryProvider);
  return GetUserFeedUseCase(repo);
});

// Reaction use cases
final createReactionUseCaseProvider = Provider<CreateReactionUseCase>((ref) {
  final repo = ref.watch(reactionRepositoryProvider);
  return CreateReactionUseCase(repo);
});

final getReactionsByPostUseCaseProvider = Provider<GetReactionsByPostUseCase>((ref) {
  final repo = ref.watch(reactionRepositoryProvider);
  return GetReactionsByPostUseCase(repo);
});

final deleteReactionUseCaseProvider = Provider<DeleteReactionUseCase>((ref) {
  final repo = ref.watch(reactionRepositoryProvider);
  return DeleteReactionUseCase(repo);
});

// Subscription use cases
final createSubscriptionUseCaseProvider = Provider<CreateSubscriptionUseCase>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return CreateSubscriptionUseCase(repo);
});

final deleteSubscriptionUseCaseProvider = Provider<DeleteSubscriptionUseCase>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return DeleteSubscriptionUseCase(repo);
});

final getSubscriptionsByCommunityUseCaseProvider = Provider<GetSubscriptionsByCommunityUseCase>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return GetSubscriptionsByCommunityUseCase(repo);
});

final getSubscriptionsByUserUseCaseProvider = Provider<GetSubscriptionsByUserUseCase>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return GetSubscriptionsByUserUseCase(repo);
});

final getUserSubscriptionForCommunityUseCaseProvider = Provider<GetUserSubscriptionForCommunityUseCase>((ref) {
  final repo = ref.watch(subscriptionRepositoryProvider);
  return GetUserSubscriptionForCommunityUseCase(repo);
});

// Controllers
final communityControllerProvider = NotifierProvider<CommunityController, CommunityState>(
  CommunityController.new,
);

final postControllerProvider = NotifierProvider<PostController, PostState>(
  PostController.new,
);

final feedControllerProvider = NotifierProvider<FeedController, FeedState>(
  FeedController.new,
);

final reactionControllerProvider = NotifierProvider<ReactionController, ReactionState>(
  ReactionController.new,
);

final subscriptionControllerProvider = NotifierProvider<SubscriptionController, SubscriptionState>(
  SubscriptionController.new,
);
