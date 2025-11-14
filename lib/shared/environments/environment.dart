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

  // Class/Quiz service endpoints
  static const String classServerBaseUrl = 'https://pine-aka-request-linked.trycloudflare.com';

  // Quiz Management endpoints
  static const String getQuizEndpoint = '/api/v1/quizzes'; // GET /{quizId} - Get a specific quiz
  static const String updateQuizEndpoint = '/api/v1/quizzes'; // PUT /{quizId} - Update an existing quiz
  static const String deleteQuizEndpoint = '/api/v1/quizzes'; // DELETE /{quizId} - Delete a quiz
  static const String updateQuestionEndpoint = '/api/v1/quizzes'; // PUT /{quizId}/questions/{questionId} - Update a question
  static const String deleteQuestionEndpoint = '/api/v1/quizzes'; // DELETE /{quizId}/questions/{questionId} - Delete a question
  static const String createQuizEndpoint = '/api/v1/quizzes'; // POST - Create a new quiz
  static const String addQuestionEndpoint = '/api/v1/quizzes'; // POST /{quizId}/questions - Add a question
  static const String publishQuizEndpoint = '/api/v1/quizzes'; // POST /{quizId}/publish - Publish a quiz
  static const String publicQuizzesEndpoint = '/api/v1/quizzes/public'; // GET - Get public quizzes
  static const String myQuizzesEndpoint = '/api/v1/quizzes/my-quizzes'; // GET - Get my quizzes
}


