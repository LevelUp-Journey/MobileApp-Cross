// class/presentation/widgets/create_quiz_form_handler.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../pages/quiz_detail_page.dart';
import 'create_quiz_form.dart';

class CreateQuizFormHandler extends ConsumerStatefulWidget {
  const CreateQuizFormHandler({super.key});

  @override
  ConsumerState<CreateQuizFormHandler> createState() => _CreateQuizFormHandlerState();
}

class _CreateQuizFormHandlerState extends ConsumerState<CreateQuizFormHandler> {
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
          content: Text('Please log in to create a quiz'),
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
            content: Text('Quiz created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      if (next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to create quiz: ${next.error}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return CreateQuizForm(
      formKey: _formKey,
      nameController: _nameController,
      descriptionController: _descriptionController,
      categoryController: _categoryController,
      coverImageUrlController: _coverImageUrlController,
      onSubmit: _handleSubmit,
      loading: state.loading,
    );
  }
}