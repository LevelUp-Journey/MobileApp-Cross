// class/presentation/widgets/quiz_list_widget.dart
import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import 'quiz_card.dart';

class QuizListWidget extends StatelessWidget {
  final List<Quiz> quizzes;
  final VoidCallback onRefresh;
  final Function(Quiz) onView;
  final Function(Quiz) onEdit;
  final Function(int, String) onDelete;

  const QuizListWidget({
    super.key,
    required this.quizzes,
    required this.onRefresh,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: quizzes.length,
        itemBuilder: (context, index) {
          final quiz = quizzes[index];
          return QuizCard(
            quiz: quiz,
            onView: () => onView(quiz),
            onEdit: () => onEdit(quiz),
            onDelete: () => onDelete(quiz.id, quiz.name),
          );
        },
      ),
    );
  }
}