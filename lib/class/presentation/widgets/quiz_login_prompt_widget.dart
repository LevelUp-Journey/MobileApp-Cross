// class/presentation/widgets/quiz_login_prompt_widget.dart
import 'package:flutter/material.dart';

class QuizLoginPromptWidget extends StatelessWidget {
  const QuizLoginPromptWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.login, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Please log in to view your quizzes',
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}