// class/application/use_cases/get_my_quizzes_use_case.dart
import '../../domain/entities/quiz.dart';
import '../../domain/repositories/quiz_repository.dart';

class GetMyQuizzesUseCase {
  final QuizRepository repository;

  GetMyQuizzesUseCase(this.repository);

  Future<List<Quiz>> execute({
    required String userId,
    required String token,
    required String userRole,
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    return await repository.getMyQuizzes(
      userId: userId,
      token: token,
      userRole: userRole,
      category: category,
      search: search,
      page: page,
      size: size,
    );
  }
}
