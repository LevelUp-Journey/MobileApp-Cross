// class/presentation/controllers/my_quizzes_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../../application/use_cases/get_my_quizzes_use_case.dart';

class MyQuizzesState {
  final bool loading;
  final List<Quiz> quizzes;
  final String? error;

  const MyQuizzesState({
    this.loading = false,
    this.quizzes = const [],
    this.error,
  });

  MyQuizzesState copyWith({
    bool? loading,
    List<Quiz>? quizzes,
    String? error,
  }) =>
      MyQuizzesState(
        loading: loading ?? this.loading,
        quizzes: quizzes ?? this.quizzes,
        error: error,
      );
}

class MyQuizzesController extends Notifier<MyQuizzesState> {
  late final GetMyQuizzesUseCase _getMyQuizzes;

  @override
  MyQuizzesState build() {
    return const MyQuizzesState();
  }

  void setDependencies(GetMyQuizzesUseCase getMyQuizzes) {
    _getMyQuizzes = getMyQuizzes;
  }

  Future<void> loadQuizzes({
    required String userId,
    required String token,
    required String userRole,
    String? category,
    String? search,
    int page = 0,
    int size = 20,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final quizzes = await _getMyQuizzes.execute(
        userId: userId,
        token: token,
        userRole: userRole,
        category: category,
        search: search,
        page: page,
        size: size,
      );
      state = MyQuizzesState(quizzes: quizzes);
    } catch (e) {
      state = MyQuizzesState(error: e.toString());
    }
  }

  void reset() {
    state = const MyQuizzesState();
  }
}
