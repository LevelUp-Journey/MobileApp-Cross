// class/presentation/widgets/quiz_card.dart
import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import 'quiz_status_badge.dart';
import 'quiz_info_chip.dart';

class QuizCard extends StatelessWidget {
  final Quiz quiz;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onView;

  const QuizCard({
    super.key,
    required this.quiz,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      quiz.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  QuizStatusBadge(isPublic: quiz.isPublic),
                  if (onEdit != null || onDelete != null || onView != null)
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'view':
                            onView?.call();
                            break;
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onView != null)
                          const PopupMenuItem(
                            value: 'view',
                            child: Row(
                              children: [
                                Icon(Icons.visibility),
                                SizedBox(width: 8),
                                Text('View Details'),
                              ],
                            ),
                          ),
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete',
                                    style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                quiz.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 12),

              // Category and Stats
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
      ),
    );
  }
}
