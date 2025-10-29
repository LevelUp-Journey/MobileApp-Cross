// class/presentation/widgets/quiz_status_chip.dart
import 'package:flutter/material.dart';

class QuizStatusChip extends StatelessWidget {
  final bool isPublic;

  const QuizStatusChip({super.key, required this.isPublic});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isPublic ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPublic ? Icons.public : Icons.lock,
            size: 16,
            color: isPublic ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            isPublic ? 'Public' : 'Private',
            style: TextStyle(
              fontSize: 12,
              color: isPublic ? Colors.green.shade700 : Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}