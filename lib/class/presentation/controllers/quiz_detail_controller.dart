// class/presentation/controllers/quiz_detail_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import 'providers.dart';

class QuizDetailState {
  final Quiz? quiz;
  final bool loading;
  final String? error;

  QuizDetailState({
    this.quiz,
    this.loading = false,
    this.error,
  });

  QuizDetailState copyWith({
    Quiz? quiz,
    bool? loading,
    String? error,
  }) {
    return QuizDetailState(
      quiz: quiz ?? this.quiz,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}

class QuizDetailController extends Notifier<QuizDetailState> {
  @override
  QuizDetailState build() {
    return QuizDetailState();
  }

  Future<void> loadQuiz({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final getQuizByIdUseCase = ref.read(getQuizByIdUseCaseProvider);
      final quiz = await getQuizByIdUseCase.execute(
        quizId: quizId,
        userId: userId,
        token: token,
        userRole: userRole,
      );

      state = state.copyWith(loading: false, quiz: quiz);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> publishQuiz({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final publishQuizUseCase = ref.read(publishQuizUseCaseProvider);
      await publishQuizUseCase.execute(
        quizId: quizId,
        userId: userId,
        token: token,
        userRole: userRole,
      );

      // Reload quiz to get updated state
      await loadQuiz(
        quizId: quizId,
        userId: userId,
        token: token,
        userRole: userRole,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> deleteQuiz({
    required int quizId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null);

    try {
      final deleteQuizUseCase = ref.read(deleteQuizUseCaseProvider);
      await deleteQuizUseCase.execute(
        quizId: quizId,
        userId: userId,
        token: token,
        userRole: userRole,
      );

      state = state.copyWith(loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}
