// class/domain/repositories/quiz_repository.dart
import '../entities/quiz.dart';

abstract class QuizRepository {
  /// Create a new quiz
  Future<int> createQuiz({
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String creatorId,
    required String token,
    required String userRole,
  });

  /// Get a specific quiz by ID
  Future<Quiz> getQuizById({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
    bool includeQuestions = true,
  });

  /// Update an existing quiz
  Future<void> updateQuiz({
    required int quizId,
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String userId,
  });

  /// Delete a quiz
  Future<void> deleteQuiz({
    required int quizId,
    required String userId,
  });

  /// Add a question to a quiz
  Future<int> addQuestion({
    required int quizId,
    required String questionText,
    required String questionType,
    required int timeLimit,
    required int points,
    required List<String> answers,
    required int correctAnswerIndex,
    String? mediaUrl,
    required String userId,
  });

  /// Update a question in a quiz
  Future<void> updateQuestion({
    required int quizId,
    required int questionId,
    required String questionText,
    required String questionType,
    required int timeLimit,
    required int points,
    required List<String> answers,
    required int correctAnswerIndex,
    String? mediaUrl,
    required String userId,
  });

  /// Delete a question from a quiz
  Future<void> deleteQuestion({
    required int quizId,
    required int questionId,
    required String userId,
  });

  /// Publish a quiz
  Future<void> publishQuiz({
    required int quizId,
    required String userId,
  });

  /// Get public quizzes (paginated)
  Future<List<Quiz>> getPublicQuizzes({
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  });

  /// Get quizzes created by the current user (paginated)
  Future<List<Quiz>> getMyQuizzes({
    required String userId,
    required String token,
    required String userRole,
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  });
}
