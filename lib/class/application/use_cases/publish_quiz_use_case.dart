// class/application/use_cases/publish_quiz_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class PublishQuizUseCase {
  final QuizRepository repository;

  PublishQuizUseCase(this.repository);

  Future<void> execute({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    return await repository.publishQuiz(
      quizId: quizId,
      userId: userId,
      token: token,
      userRole: userRole,
    );
  }
}
