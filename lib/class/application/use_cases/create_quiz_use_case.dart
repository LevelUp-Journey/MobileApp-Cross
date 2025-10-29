// class/application/use_cases/create_quiz_use_case.dart
import '../../domain/repositories/quiz_repository.dart';

class CreateQuizUseCase {
  final QuizRepository repository;

  CreateQuizUseCase(this.repository);

  Future<int> execute({
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String creatorId,
    required String token,
    required String userRole,
  }) async {
    return await repository.createQuiz(
      name: name,
      description: description,
      category: category,
      coverImageUrl: coverImageUrl,
      creatorId: creatorId,
      token: token,
      userRole: userRole,
    );
  }
}
