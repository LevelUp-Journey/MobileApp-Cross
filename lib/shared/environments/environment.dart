// lib/shared/environments/environment.dart
class Environment {
  static const bool production = false; // Assuming dev for now
  static const String iamserverBaseUrl = 'http://localhost:8081';
  static const String signUpEndpoint = '/api/v1/authentication/sign-up';
  static const String signInEndpoint = '/api/v1/authentication/sign-in';
  static const String validateTokenEndpoint = '/api/v1/authentication/validate';
  static const String refreshTokenEndpoint = '/api/v1/authentication/refresh';

  // Profile service endpoints
  static const String profileserverBaseUrl = 'http://localhost:8082';
  static const String getProfileByUserIdEndpoint = '/api/v1/profiles/user';
  static const String updateProfileEndpoint = '/api/v1/profiles';

  // Community service endpoints
  static const String communityserverBaseUrl = 'http://localhost:8086';
  static const String getAllCommunitiesEndpoint = '/api/v1/communities';

  // Class/Quiz service endpoints
  static const String classServerBaseUrl = 'http://localhost:8088';

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


