// class/presentation/controllers/create_quiz_controller.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../application/use_cases/create_quiz_use_case.dart';

class CreateQuizState {
  final bool loading;
  final int? createdQuizId;
  final String? error;

  const CreateQuizState({
    this.loading = false,
    this.createdQuizId,
    this.error,
  });

  CreateQuizState copyWith({
    bool? loading,
    int? createdQuizId,
    String? error,
  }) =>
      CreateQuizState(
        loading: loading ?? this.loading,
        createdQuizId: createdQuizId ?? this.createdQuizId,
        error: error,
      );
}

class CreateQuizController extends Notifier<CreateQuizState> {
  late final CreateQuizUseCase _createQuiz;

  @override
  CreateQuizState build() {
    return const CreateQuizState();
  }

  void setDependencies(CreateQuizUseCase createQuiz) {
    _createQuiz = createQuiz;
  }

  Future<void> submit({
    required String name,
    required String description,
    required String category,
    String? coverImageUrl,
    required String creatorId,
    required String token,
    required String userRole,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final quizId = await _createQuiz.execute(
        name: name,
        description: description,
        category: category,
        coverImageUrl: coverImageUrl,
        creatorId: creatorId,
        token: token,
        userRole: userRole,
      );
      state = CreateQuizState(createdQuizId: quizId);
    } catch (e) {
      state = CreateQuizState(error: e.toString());
    }
  }

  void reset() {
    state = const CreateQuizState();
  }
}
