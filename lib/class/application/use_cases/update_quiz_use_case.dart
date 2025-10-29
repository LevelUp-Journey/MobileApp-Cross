// class/application/use_cases/update_quiz_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class UpdateQuizUseCase {
  final QuizRepository repository;

  UpdateQuizUseCase(this.repository);

  Future<void> execute({
    required int quizId,
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    return await repository.updateQuiz(
      quizId: quizId,
      name: name,
      description: description,
      category: category,
      coverImageUrl: coverImageUrl,
      userId: userId,
      token: token,
      userRole: userRole,
    );
  }
}