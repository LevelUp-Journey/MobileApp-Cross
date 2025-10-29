// class/application/use_cases/update_question_use_case.dart
import '../../domain/repositories/question_repository.dart';

class UpdateQuestionUseCase {
  final QuestionRepository repository;

  UpdateQuestionUseCase(this.repository);

  Future<void> execute({
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
    required String token,
    required String userRole,
  }) async {
    return await repository.updateQuestion(
      quizId: quizId,
      questionId: questionId,
      questionText: questionText,
      questionType: questionType,
      timeLimit: timeLimit,
      points: points,
      answers: answers,
      correctAnswerIndex: correctAnswerIndex,
      mediaUrl: mediaUrl,
      userId: userId,
      token: token,
      userRole: userRole,
    );
  }
}
