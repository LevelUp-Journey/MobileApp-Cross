// class/application/use_cases/delete_question_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class DeleteQuestionUseCase {
  final QuizRepository repository;

  DeleteQuestionUseCase(this.repository);

  Future<void> execute({
    required int quizId,
    required int questionId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    return await repository.deleteQuestion(
      quizId: quizId,
      questionId: questionId,
      userId: userId,
      token: token,
      userRole: userRole,
    );
  }
}
