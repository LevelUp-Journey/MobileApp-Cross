// class/presentation/controllers/question_form_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

class QuestionFormState {
  final bool loading;
  final String? error;
  final int? createdQuestionId;
  final bool success;

  QuestionFormState({
    this.loading = false,
    this.error,
    this.createdQuestionId,
    this.success = false,
  });

  QuestionFormState copyWith({
    bool? loading,
    String? error,
    int? createdQuestionId,
    bool? success,
  }) {
    return QuestionFormState(
      loading: loading ?? this.loading,
      error: error,
      createdQuestionId: createdQuestionId ?? this.createdQuestionId,
      success: success ?? this.success,
    );
  }
}

class QuestionFormController extends Notifier<QuestionFormState> {
  @override
  QuestionFormState build() {
    return QuestionFormState();
  }

  Future<void> addQuestion({
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
    state = state.copyWith(loading: true, error: null, success: false);

    try {
      final addQuestionUseCase = ref.read(addQuestionUseCaseProvider);
      final questionId = await addQuestionUseCase.execute(
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

      state = state.copyWith(
        loading: false,
        success: true,
        createdQuestionId: questionId,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> updateQuestion({
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
    state = state.copyWith(loading: true, error: null, success: false);

    try {
      final updateQuestionUseCase = ref.read(updateQuestionUseCaseProvider);
      await updateQuestionUseCase.execute(
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

      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<void> deleteQuestion({
    required int quizId,
    required int questionId,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null, success: false);

    try {
      final deleteQuestionUseCase = ref.read(deleteQuestionUseCaseProvider);
      await deleteQuestionUseCase.execute(
        quizId: quizId,
        questionId: questionId,
        userId: userId,
        token: token,
        userRole: userRole,
      );

      state = state.copyWith(loading: false, success: true);
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void reset() {
    state = QuestionFormState();
  }
}
