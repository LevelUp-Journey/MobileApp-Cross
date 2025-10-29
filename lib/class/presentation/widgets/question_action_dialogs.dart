// class/presentation/widgets/question_action_dialogs.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart' as class_providers;
import '../../../iam/presentation/controllers/providers.dart';

class QuestionActionDialogs {
  static void showDeleteDialog(BuildContext context, WidgetRef ref, int quizId, int questionId, VoidCallback onQuestionDeleted) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
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

              await ref.read(class_providers.questionFormControllerProvider.notifier).deleteQuestion(
                    quizId: quizId,
                    questionId: questionId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!context.mounted) return;

              final questionState = ref.read(class_providers.questionFormControllerProvider);
              if (questionState.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question deleted'), backgroundColor: Colors.green),
                );
                onQuestionDeleted();
              } else if (questionState.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${questionState.error}'), backgroundColor: Colors.red),
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