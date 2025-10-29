// class/presentation/pages/create_quiz_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import 'quiz_detail_page.dart';

class CreateQuizPage extends ConsumerStatefulWidget {
  const CreateQuizPage({super.key});

  @override
  ConsumerState<CreateQuizPage> createState() => _CreateQuizPageState();
}

class _CreateQuizPageState extends ConsumerState<CreateQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _coverImageUrlController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _coverImageUrlController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authControllerProvider);
    if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to create a quiz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = ref.read(createQuizControllerProvider.notifier);
    controller.submit(
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      coverImageUrl: _coverImageUrlController.text.trim().isEmpty
          ? null
          : _coverImageUrlController.text.trim(),
      creatorId: authState.user!.id,
      token: authState.token!,
      userRole: authState.roles.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createQuizControllerProvider);

    // Listen for successful creation
    ref.listen(createQuizControllerProvider, (previous, next) {
      if (next.createdQuizId != null) {
        // Reset form and controller
        _formKey.currentState?.reset();
        _nameController.clear();
        _descriptionController.clear();
        _categoryController.clear();
        _coverImageUrlController.clear();
        ref.read(createQuizControllerProvider.notifier).reset();

        // Navigate to quiz detail page to add questions
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => QuizDetailPage(quizId: next.createdQuizId!),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz created! Now add some questions.'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Quiz'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Quiz Name Field
              TextFormField(
                controller: _nameController,
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
                controller: _descriptionController,
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
                controller: _categoryController,
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
                controller: _coverImageUrlController,
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
                onPressed: state.loading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: state.loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text(
                        'Create Quiz',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
