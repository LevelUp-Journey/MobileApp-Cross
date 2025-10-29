// class/application/use_cases/get_quiz_by_id_use_case.dart
import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class GetQuizByIdUseCase {
  final QuizRepository repository;

  GetQuizByIdUseCase(this.repository);

  Future<Quiz> execute({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
    bool includeQuestions = true,
  }) async {
    return await repository.getQuizById(
      quizId: quizId,
      userId: userId,
      token: token,
      userRole: userRole,
      includeQuestions: includeQuestions,
    );
  }
}
