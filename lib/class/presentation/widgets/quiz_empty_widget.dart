// class/presentation/widgets/quiz_empty_widget.dart
import 'package:flutter/material.dart';

class QuizEmptyWidget extends StatelessWidget {
  const QuizEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.quiz_outlined, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'No quizzes yet',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 8),
          Text(
            'Create your first quiz to get started!',
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}