// class/presentation/pages/my_quizzes_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import 'create_quiz_page.dart';
import '../widgets/quiz_loading_widget.dart';
import '../widgets/quiz_error_widget.dart';
import '../widgets/quiz_empty_widget.dart';
import '../widgets/quiz_login_prompt_widget.dart';
import '../widgets/quiz_list_widget.dart';

class MyQuizzesPage extends ConsumerStatefulWidget {
  const MyQuizzesPage({super.key});

  @override
  ConsumerState<MyQuizzesPage> createState() => _MyQuizzesPageState();
}

class _MyQuizzesPageState extends ConsumerState<MyQuizzesPage> {
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(myQuizzesControllerProvider);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes'),
        elevation: 0,
      ),
      body: _buildBody(state, authState),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuizPage(),
            ),
          );
          // Reload quizzes after returning from create page
          _loadQuizzes();
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Quiz'),
      ),
    );
  }

  Widget _buildBody(state, authState) {
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
      onDelete: _showDeleteDialog,
    );
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
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Authentication required'),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }

              try {
                final deleteUseCase = ref.read(deleteQuizUseCaseProvider);
                await deleteUseCase.execute(
                  quizId: quizId,
                  userId: authState.user!.id,
                  token: authState.token!,
                  userRole: authState.roles.first,
                );
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Quiz deleted successfully'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                // Reload quizzes
                _loadQuizzes();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error deleting quiz: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
