// class/application/use_cases/delete_quiz_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class DeleteQuizUseCase {
  final QuizRepository repository;

  DeleteQuizUseCase(this.repository);

  Future<void> execute({
    required int quizId,
    required String userId,
  }) async {
    return await repository.deleteQuiz(
      quizId: quizId,
      userId: userId,
    );
  }
}
