// class/presentation/controllers/providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../../shared/environments/environment.dart';
import '../../application/use_cases/create_quiz_use_case.dart';
import '../../application/use_cases/get_my_quizzes_use_case.dart';
import '../../application/use_cases/get_quiz_by_id_use_case.dart';
import '../../application/use_cases/delete_quiz_use_case.dart';
import '../../application/use_cases/update_quiz_use_case.dart';
import '../../application/use_cases/add_question_use_case.dart';
import '../../application/use_cases/update_question_use_case.dart';
import '../../application/use_cases/delete_question_use_case.dart';
import '../../application/use_cases/publish_quiz_use_case.dart';
import '../../infrastructure/repositories_impl/rest_quiz_repository.dart';
import '../../domain/repositories/quiz_repository.dart';
import 'create_quiz_controller.dart';
import 'my_quizzes_controller.dart';
import 'update_quiz_controller.dart';
import 'quiz_detail_controller.dart';
import 'question_form_controller.dart';

// HTTP Client Provider (shared across the app)
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

// Base URL Provider for Quiz Service
final quizBaseUrlProvider = Provider<String>(
  (ref) => Environment.classServerBaseUrl,
);

// Quiz Repository Provider
final quizRepositoryProvider = Provider<QuizRepository>((ref) {
  final client = ref.watch(httpClientProvider);
  final baseUrl = ref.watch(quizBaseUrlProvider);
  return RestQuizRepository(client, baseUrl: baseUrl);
});

// Use Cases Providers
final createQuizUseCaseProvider = Provider<CreateQuizUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return CreateQuizUseCase(repo);
});

final getMyQuizzesUseCaseProvider = Provider<GetMyQuizzesUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return GetMyQuizzesUseCase(repo);
});

final getQuizByIdUseCaseProvider = Provider<GetQuizByIdUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return GetQuizByIdUseCase(repo);
});

final deleteQuizUseCaseProvider = Provider<DeleteQuizUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return DeleteQuizUseCase(repo);
});

final updateQuizUseCaseProvider = Provider<UpdateQuizUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return UpdateQuizUseCase(repo);
});

final addQuestionUseCaseProvider = Provider<AddQuestionUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return AddQuestionUseCase(repo);
});

final updateQuestionUseCaseProvider = Provider<UpdateQuestionUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return UpdateQuestionUseCase(repo);
});

final deleteQuestionUseCaseProvider = Provider<DeleteQuestionUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return DeleteQuestionUseCase(repo);
});

final publishQuizUseCaseProvider = Provider<PublishQuizUseCase>((ref) {
  final repo = ref.watch(quizRepositoryProvider);
  return PublishQuizUseCase(repo);
});

// Controllers Providers
final createQuizControllerProvider =
    NotifierProvider<CreateQuizController, CreateQuizState>(() {
  return CreateQuizController()
    ..setDependencies(
      CreateQuizUseCase(
        RestQuizRepository(
          http.Client(),
          baseUrl: Environment.classServerBaseUrl,
        ),
      ),
    );
});

final myQuizzesControllerProvider =
    NotifierProvider<MyQuizzesController, MyQuizzesState>(() {
  return MyQuizzesController()
    ..setDependencies(
      GetMyQuizzesUseCase(
        RestQuizRepository(
          http.Client(),
          baseUrl: Environment.classServerBaseUrl,
        ),
      ),
    );
});

final updateQuizControllerProvider =
    NotifierProvider<UpdateQuizController, UpdateQuizState>(() {
  return UpdateQuizController()
    ..setDependencies(
      UpdateQuizUseCase(
        RestQuizRepository(
          http.Client(),
          baseUrl: Environment.classServerBaseUrl,
        ),
      ),
    );
});

final quizDetailControllerProvider =
    NotifierProvider<QuizDetailController, QuizDetailState>(() {
  return QuizDetailController();
});

final questionFormControllerProvider =
    NotifierProvider<QuestionFormController, QuestionFormState>(() {
  return QuestionFormController();
});
