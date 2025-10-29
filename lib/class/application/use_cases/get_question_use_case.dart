// class/application/use_cases/get_question_use_case.dart
import '../../domain/repositories/quiz_repository.dart';
import '../../domain/entities/question.dart';

class GetQuestionUseCase {
  final QuizRepository repository;

  GetQuestionUseCase(this.repository);

  Future<Question> execute({
    required int quizId,
    required int questionId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    return await repository.getQuestionById(
      quizId: quizId,
      questionId: questionId,
      userId: userId,
      token: token,
      userRole: userRole,
    );
  }
}