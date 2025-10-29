import 'package:flutter/material.dart';
import '../widgets/create_quiz_form_handler.dart';

class CreateQuizPage extends StatelessWidget {
  const CreateQuizPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        elevation: 0,
      ),
      body: const CreateQuizFormHandler(),
    );
  }
}
