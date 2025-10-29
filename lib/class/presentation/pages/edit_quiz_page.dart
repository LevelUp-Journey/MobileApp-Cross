import 'package:flutter/material.dart';
import '../../domain/entities/quiz.dart';
import '../widgets/edit_quiz_form_handler.dart';

class EditQuizPage extends StatelessWidget {
  final Quiz quiz;

  const EditQuizPage({super.key, required this.quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Quiz'),
        elevation: 0,
      ),
      body: EditQuizFormHandler(quiz: quiz),
    );
  }
}