// class/presentation/widgets/quiz_detail_content.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/providers.dart' as class_providers;
import '../../../iam/presentation/controllers/providers.dart';
import '../pages/question_form_page.dart';
import 'quiz_header_card.dart';
import 'quiz_questions_section.dart';
import 'quiz_action_dialogs.dart';
import 'question_action_dialogs.dart';

class QuizDetailContent extends ConsumerStatefulWidget {
  final Quiz quiz;

  const QuizDetailContent({super.key, required this.quiz});

  @override
  ConsumerState<QuizDetailContent> createState() => _QuizDetailContentState();
}

class _QuizDetailContentState extends ConsumerState<QuizDetailContent> {
  void _loadQuiz() {
    final authState = ref.read(authControllerProvider);
    if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
      ref.read(class_providers.quizDetailControllerProvider.notifier).loadQuiz(
            quizId: widget.quiz.id,
            userId: authState.user!.id,
            token: authState.token!,
            userRole: authState.roles.first,
          );
    }
  }

  void _addQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionFormPage(quizId: widget.quiz.id),
      ),
    ).then((_) => _loadQuiz());
  }

  void _editQuestion(int questionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionFormPage(
          quizId: widget.quiz.id,
          questionId: questionId,
        ),
      ),
    ).then((_) => _loadQuiz());
  }

  void _deleteQuestion(int questionId) {
    QuestionActionDialogs.showDeleteDialog(
      context,
      ref,
      widget.quiz.id,
      questionId,
      _loadQuiz,
    );
  }

  void _showEditDialog() {
    QuizActionDialogs.showEditDialog(context, ref, widget.quiz, _loadQuiz);
  }

  void _publishQuiz() {
    QuizActionDialogs.showPublishDialog(context, ref, widget.quiz.id, _loadQuiz);
  }

  void _showDeleteDialog() {
    QuizActionDialogs.showDeleteDialog(context, ref, widget.quiz.id, () {
      Navigator.pop(context); // Go back to previous screen
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditDialog();
                  break;
                case 'publish':
                  _publishQuiz();
                  break;
                case 'delete':
                  _showDeleteDialog();
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit),
                    SizedBox(width: 8),
                    Text('Edit Quiz'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'publish',
                child: Row(
                  children: [
                    Icon(Icons.publish),
                    SizedBox(width: 8),
                    Text('Publish Quiz'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Delete Quiz', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            QuizHeaderCard(quiz: widget.quiz),
            QuizQuestionsSection(
              questions: widget.quiz.questions,
              onEditQuestion: _editQuestion,
              onDeleteQuestion: _deleteQuestion,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addQuestion,
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
    );
  }
}