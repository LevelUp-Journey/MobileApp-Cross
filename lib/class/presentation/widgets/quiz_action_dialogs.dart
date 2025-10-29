// class/presentation/widgets/quiz_action_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/providers.dart' as class_providers;
import '../../../iam/presentation/controllers/providers.dart';
import '../pages/edit_quiz_page.dart';

class QuizActionDialogs {
  static void showEditDialog(BuildContext context, WidgetRef ref, Quiz quiz, VoidCallback onQuizUpdated) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuizPage(quiz: quiz),
      ),
    ).then((updated) {
      // Reload quiz if it was updated
      if (updated == true) {
        onQuizUpdated();
      }
    });
  }

  static void showPublishDialog(BuildContext context, WidgetRef ref, int quizId, VoidCallback onQuizReload) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish Quiz'),
        content: const Text('Make this quiz available to the public?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final authState = ref.read(authControllerProvider);
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication error'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              await ref.read(class_providers.quizDetailControllerProvider.notifier).publishQuiz(
                    quizId: quizId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!context.mounted) return;

              final detailState = ref.read(class_providers.quizDetailControllerProvider);
              if (detailState.error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz published!'), backgroundColor: Colors.green),
                );
                onQuizReload();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${detailState.error}'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  static void showDeleteDialog(BuildContext context, WidgetRef ref, int quizId, VoidCallback onQuizDeleted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure you want to delete this quiz? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final authState = ref.read(authControllerProvider);
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication error'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              await ref.read(class_providers.quizDetailControllerProvider.notifier).deleteQuiz(
                    quizId: quizId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!context.mounted) return;

              final detailState = ref.read(class_providers.quizDetailControllerProvider);
              if (detailState.error == null) {
                onQuizDeleted();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz deleted'), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${detailState.error}'), backgroundColor: Colors.red),
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