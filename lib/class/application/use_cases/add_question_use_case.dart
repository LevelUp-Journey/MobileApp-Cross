// class/application/use_cases/add_question_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class AddQuestionUseCase {
  final QuizRepository repository;

  AddQuestionUseCase(this.repository);

  Future<int> execute({
    required int quizId,
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
    return await repository.addQuestion(
      quizId: quizId,
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
