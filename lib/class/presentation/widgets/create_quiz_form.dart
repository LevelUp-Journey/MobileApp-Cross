// class/presentation/widgets/create_quiz_form.dart
import 'package:flutter/material.dart';
import 'quiz_form.dart';

class CreateQuizForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController coverImageUrlController;
  final VoidCallback onSubmit;
  final bool loading;

  const CreateQuizForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.categoryController,
    required this.coverImageUrlController,
    required this.onSubmit,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return QuizForm(
      formKey: formKey,
      nameController: nameController,
      descriptionController: descriptionController,
      categoryController: categoryController,
      coverImageUrlController: coverImageUrlController,
      onSubmit: onSubmit,
      loading: loading,
      submitButtonText: 'Create Quiz',
    );
  }
}