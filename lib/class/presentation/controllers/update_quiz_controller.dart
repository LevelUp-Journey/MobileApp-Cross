// class/presentation/controllers/update_quiz_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/use_cases/update_quiz_use_case.dart';

class UpdateQuizState {
  final bool loading;
  final bool? success;
  final String? error;

  const UpdateQuizState({
    this.loading = false,
    this.success,
    this.error,
  });

  UpdateQuizState copyWith({
    bool? loading,
    bool? success,
    String? error,
  }) =>
      UpdateQuizState(
        loading: loading ?? this.loading,
        success: success ?? this.success,
        error: error,
      );
}

class UpdateQuizController extends Notifier<UpdateQuizState> {
  late final UpdateQuizUseCase _updateQuiz;

  @override
  UpdateQuizState build() {
    return const UpdateQuizState();
  }

  void setDependencies(UpdateQuizUseCase updateQuiz) {
    _updateQuiz = updateQuiz;
  }

  Future<void> submit({
    required int quizId,
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String userId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null, success: null);
    try {
      await _updateQuiz.execute(
        quizId: quizId,
        name: name,
        description: description,
        category: category,
        coverImageUrl: coverImageUrl,
        userId: userId,
        token: token,
        userRole: userRole,
      );
      state = const UpdateQuizState(success: true);
    } catch (e) {
      state = UpdateQuizState(error: e.toString());
    }
  }

  void reset() {
    state = const UpdateQuizState();
  }
}