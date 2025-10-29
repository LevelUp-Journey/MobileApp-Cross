// class/presentation/widgets/my_quizzes_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../pages/edit_quiz_page.dart';
import '../pages/quiz_detail_page.dart';
import 'quiz_loading_widget.dart';
import 'quiz_error_widget.dart';
import 'quiz_empty_widget.dart';
import 'quiz_login_prompt_widget.dart';
import 'quiz_list_widget.dart';

class MyQuizzesContent extends ConsumerStatefulWidget {
  const MyQuizzesContent({super.key});

  @override
  ConsumerState<MyQuizzesContent> createState() => _MyQuizzesContentState();
}

class _MyQuizzesContentState extends ConsumerState<MyQuizzesContent> {
  @override
  void initState() {
    super.initState();
    // Load quizzes after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuizzes();
    });
  }
  void _loadQuizzes() {
    final authState = ref.read(authControllerProvider);
    if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
      ref.read(myQuizzesControllerProvider.notifier).loadQuizzes(
            userId: authState.user!.id,
            token: authState.token!,
            userRole: authState.roles.first,
          );
    }
  }

  void _navigateToQuizDetail(dynamic quiz) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuizDetailPage(quizId: quiz.id),
      ),
    );
  }

  void _navigateToEditQuiz(dynamic quiz) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuizPage(quiz: quiz),
      ),
    );
    // Reload quizzes after returning from edit page
    _loadQuizzes();
  }

  void _showDeleteDialog(int quizId, String quizName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: Text('Are you sure you want to delete "$quizName"? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog

              final authState = ref.read(authControllerProvider);
              if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
                try {
                  await ref.read(deleteQuizUseCaseProvider).execute(
                        quizId: quizId,
                        userId: authState.user!.id,
                        token: authState.token!,
                        userRole: authState.roles.first,
                      );

                  // Reload quizzes after deletion
                  _loadQuizzes();

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Quiz deleted successfully')),
                    );
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to delete quiz: $e')),
                    );
                  }
                }
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myQuizzesControllerProvider);
    final authState = ref.watch(authControllerProvider);

    if (authState.user == null) {
      return const QuizLoginPromptWidget();
    }

    if (state.loading) {
      return const QuizLoadingWidget();
    }

    if (state.error != null) {
      return QuizErrorWidget(error: state.error!, onRetry: _loadQuizzes);
    }

    if (state.quizzes.isEmpty) {
      return const QuizEmptyWidget();
    }

    return QuizListWidget(
      quizzes: state.quizzes,
      onRefresh: _loadQuizzes,
      onView: _navigateToQuizDetail,
      onEdit: _navigateToEditQuiz,
      onDelete: _showDeleteDialog,
    );
  }
}