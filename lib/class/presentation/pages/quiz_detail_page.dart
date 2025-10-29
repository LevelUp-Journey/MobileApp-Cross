// class/presentation/pages/quiz_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/providers.dart' as class_providers;
import '../../../iam/presentation/controllers/providers.dart';
import '../widgets/quiz_detail_content.dart';

class QuizDetailPage extends ConsumerStatefulWidget {
  final int quizId;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends ConsumerState<QuizDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuiz();
    });
  }

  void _loadQuiz() {
    final authState = ref.read(authControllerProvider);
    if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
      ref.read(class_providers.quizDetailControllerProvider.notifier).loadQuiz(
            quizId: widget.quizId,
            userId: authState.user!.id,
            token: authState.token!,
            userRole: authState.roles.first,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizDetailState = ref.watch(class_providers.quizDetailControllerProvider);
    final Quiz? quiz = quizDetailState.quiz;
    final bool loading = quizDetailState.loading;
    final String? error = quizDetailState.error;

    // Show error snackbar if there's an error
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(class_providers.quizDetailControllerProvider.notifier).clearError();
              },
            ),
          ),
        );
        ref.read(class_providers.quizDetailControllerProvider.notifier).clearError();
      });
    }

    if (loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Details'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (quiz == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Details'),
        ),
        body: const Center(child: Text('Quiz not found')),
      );
    }

    return QuizDetailContent(quiz: quiz);
  }
}
