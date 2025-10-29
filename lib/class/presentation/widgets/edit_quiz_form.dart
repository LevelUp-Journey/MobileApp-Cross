// class/presentation/widgets/edit_quiz_form.dart
import 'package:flutter/material.dart';

class EditQuizForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController categoryController;
  final TextEditingController coverImageUrlController;
  final VoidCallback onSubmit;
  final bool loading;

  const EditQuizForm({
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Quiz Name Field
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Quiz Name',
                hintText: 'Enter quiz name',
                prefixIcon: Icon(Icons.quiz),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
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
              },
              maxLength: 100,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Description Field
            TextFormField(
              controller: descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter quiz description',
                prefixIcon: Icon(Icons.description),
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Description is required';
                }
                if (value.trim().length < 10) {
                  return 'Description must be at least 10 characters';
                }
                return null;
              },
              maxLines: 4,
              maxLength: 500,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),

            // Category Field
            TextFormField(
              controller: categoryController,
              decoration: const InputDecoration(
                labelText: 'Category',
                hintText: 'e.g., Science, Math, History',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Category is required';
                }
                if (value.trim().length > 50) {
                  return 'Category must not exceed 50 characters';
                }
                return null;
              },
              maxLength: 50,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),

            // Cover Image URL Field (Optional)
            TextFormField(
              controller: coverImageUrlController,
              decoration: const InputDecoration(
                labelText: 'Cover Image URL (Optional)',
                hintText: 'https://example.com/image.jpg',
                prefixIcon: Icon(Icons.image),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.url,
            ),
            const SizedBox(height: 24),

            // Submit Button
            ElevatedButton(
              onPressed: loading ? null : onSubmit,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text(
                      'Update Quiz',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}