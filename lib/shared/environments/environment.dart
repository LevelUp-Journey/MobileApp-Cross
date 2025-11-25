// lib/shared/environments/environment.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static const bool production = false; // Assuming dev for now
  static String get baseUrl => dotenv.env['API_BASE_URL']!;
  static const String signUpEndpoint = '/authentication/sign-up';
  static const String signInEndpoint = '/authentication/sign-in';
  static const String validateTokenEndpoint = '/authentication/validate';
  static const String refreshTokenEndpoint = '/authentication/refresh';

  // Profile service endpoints
  static const String getProfileByUserIdEndpoint = '/profiles/user';
  static const String updateProfileEndpoint = '/profiles';

  // Community service endpoints
  static const String getAllCommunitiesEndpoint = '/communities';
  static const String getCommunitiesByCreatorEndpoint = '/communities/creator';
  static const String subscriptionsEndpoint = '/subscriptions';
  static const String postsEndpoint = '/posts';
  static const String feedEndpoint = '/feed';
  static const String reactionsEndpoint = '/reactions';

  static String communityById(String communityId) => '$getAllCommunitiesEndpoint/$communityId';
  static String communitiesByCreator(String creatorId) => '$getCommunitiesByCreatorEndpoint/$creatorId';
  static String postsByCommunity(String communityId) => '$postsEndpoint/community/$communityId';
  static String postsFeed(String userId) => '$postsEndpoint/feed/$userId';
  static String feedByUser(String userId) => '$feedEndpoint/$userId';
  static String reactionsByPost(String postId) => '$reactionsEndpoint/post/$postId';
  static String reactionForUserPost(String userId, String postId) => '$reactionsEndpoint/user/$userId/post/$postId';
  static String subscriptionsByCommunity(String communityId) => '$subscriptionsEndpoint/community/$communityId';
  static String subscriptionsByUser(String userId) => '$subscriptionsEndpoint/user/$userId';


}


