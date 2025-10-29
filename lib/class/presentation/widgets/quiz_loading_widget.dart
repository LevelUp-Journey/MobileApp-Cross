// class/presentation/widgets/quiz_loading_widget.dart
import 'package:flutter/material.dart';

class QuizLoadingWidget extends StatelessWidget {
  const QuizLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}