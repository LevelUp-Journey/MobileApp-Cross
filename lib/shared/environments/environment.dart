// lib/shared/environments/environment.dart
class Environment {
  static const bool production = false; // Assuming dev for now
  static const String iamserverBaseUrl = 'https://pine-aka-request-linked.trycloudflare.com';
  static const String signUpEndpoint = '/api/v1/authentication/sign-up';
  static const String signInEndpoint = '/api/v1/authentication/sign-in';
  static const String validateTokenEndpoint = '/api/v1/authentication/validate';
  static const String refreshTokenEndpoint = '/api/v1/authentication/refresh';

  // Profile service endpoints
  static const String profileserverBaseUrl = 'https://pine-aka-request-linked.trycloudflare.com';
  static const String getProfileByUserIdEndpoint = '/api/v1/profiles/user';
  static const String updateProfileEndpoint = '/api/v1/profiles';

  // Community service endpoints
  static const String communityserverBaseUrl = 'https://pine-aka-request-linked.trycloudflare.com';
  static const String getAllCommunitiesEndpoint = '/api/v1/communities';
  static const String getCommunitiesByCreatorEndpoint = '/api/v1/communities/creator';
  static const String subscriptionsEndpoint = '/api/v1/subscriptions';
  static const String postsEndpoint = '/api/v1/posts';
  static const String feedEndpoint = '/api/v1/feed';
  static const String reactionsEndpoint = '/api/v1/reactions';

  static String communityById(String communityId) => '$getAllCommunitiesEndpoint/$communityId';
  static String communitiesByCreator(String creatorId) => '$getCommunitiesByCreatorEndpoint/$creatorId';
  static String postsByCommunity(String communityId) => '${postsEndpoint}/community/$communityId';
  static String postsFeed(String userId) => '${postsEndpoint}/feed/$userId';
  static String feedByUser(String userId) => '$feedEndpoint/$userId';
  static String reactionsByPost(String postId) => '${reactionsEndpoint}/post/$postId';
  static String reactionForUserPost(String userId, String postId) => '${reactionsEndpoint}/user/$userId/post/$postId';
  static String subscriptionsByCommunity(String communityId) => '${subscriptionsEndpoint}/community/$communityId';
  static String subscriptionsByUser(String userId) => '${subscriptionsEndpoint}/user/$userId';


}


