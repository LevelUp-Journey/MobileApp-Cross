// class/presentation/widgets/quiz_questions_section.dart
import 'package:flutter/material.dart';
import '../../domain/entities/question.dart';
import 'question_list_item.dart';

class QuizQuestionsSection extends StatelessWidget {
  final List<Question> questions;
  final Function(int) onEditQuestion;
  final Function(int) onDeleteQuestion;

  const QuizQuestionsSection({
    super.key,
    required this.questions,
    required this.onEditQuestion,
    required this.onDeleteQuestion,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Questions',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        const SizedBox(height: 8),
        if (questions.isEmpty)
          const Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No questions yet',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add your first question to get started!',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: questions.length,
            itemBuilder: (context, index) {
              final question = questions[index];
              return QuestionListItem(
                question: question,
                index: index,
                onEdit: () => onEditQuestion(question.id),
                onDelete: () => onDeleteQuestion(question.id),
              );
            },
          ),
        const SizedBox(height: 80), // Space for FAB
      ],
    );
  }
}