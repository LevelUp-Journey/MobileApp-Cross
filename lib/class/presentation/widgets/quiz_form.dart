// class/presentation/widgets/quiz_form.dart
import 'package:flutter/material.dart';
import 'quiz_form_field.dart';
import 'primary_button.dart';

class QuizForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController coverImageUrlController;
  final VoidCallback onSubmit;
  final bool loading;
  final String submitButtonText;

  const QuizForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.descriptionController,
    required this.categoryController,
    required this.coverImageUrlController,
    required this.onSubmit,
    required this.loading,
    required this.submitButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quiz Name Field
            QuizFormField(
              controller: nameController,
              label: 'Quiz Name',
              hint: 'Enter quiz name',
              icon: Icons.quiz,
              validator: _validateQuizName,
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description Field
            QuizFormField(
              controller: descriptionController,
              label: 'Description',
              hint: 'Enter quiz description',
              icon: Icons.description,
              validator: _validateDescription,
              maxLength: 500,
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
              alignLabelWithHint: true,
            ),
            const SizedBox(height: 16),

            // Category Field
            QuizFormField(
              controller: categoryController,
              label: 'Category',
              hint: 'e.g., Science, Math, History',
              icon: Icons.category,
              validator: _validateCategory,
              maxLength: 50,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Cover Image URL Field (Optional)
            QuizFormField(
              controller: coverImageUrlController,
              label: 'Cover Image URL (Optional)',
              hint: 'https://example.com/image.jpg',
              icon: Icons.image,
              validator: _validateCoverImageUrl,
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),

            // Submit Button
            PrimaryButton(
              label: submitButtonText,
              onPressed: onSubmit,
              loading: loading,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  String? _validateQuizName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quiz name is required';
    }
    if (value.trim().length < 3) {
      return 'Quiz name must be at least 3 characters';
    }
    if (value.trim().length > 100) {
      return 'Quiz name must not exceed 100 characters';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Description is required';
    }
    if (value.trim().length < 10) {
      return 'Description must be at least 10 characters';
    }
    return null;
  }

  String? _validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Category is required';
    }
    if (value.trim().length > 50) {
      return 'Category must not exceed 50 characters';
    }
    return null;
  }

  String? _validateCoverImageUrl(String? value) {
    // Optional field, no validation needed
    return null;
  }
}