// class/presentation/widgets/quiz_header_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import 'quiz_status_chip.dart';
import 'quiz_info_chip.dart';

class QuizHeaderCard extends StatelessWidget {
  final Quiz quiz;

  const QuizHeaderCard({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    quiz.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                QuizStatusChip(isPublic: quiz.isPublic),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              quiz.description,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                QuizInfoChip(
                  icon: Icons.category,
                  label: quiz.category,
                ),
                QuizInfoChip(
                  icon: Icons.question_answer,
                  label: '${quiz.totalQuestions} questions',
                ),
                QuizInfoChip(
                  icon: Icons.stars,
                  label: '${quiz.totalPoints} points',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}