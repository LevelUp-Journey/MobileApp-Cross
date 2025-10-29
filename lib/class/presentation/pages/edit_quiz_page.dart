// class/presentation/pages/edit_quiz_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../domain/entities/quiz.dart';
import '../widgets/edit_quiz_form.dart';

class EditQuizPage extends ConsumerStatefulWidget {
  final Quiz quiz;

  const EditQuizPage({super.key, required this.quiz});

  @override
  ConsumerState<EditQuizPage> createState() => _EditQuizPageState();
}

class _EditQuizPageState extends ConsumerState<EditQuizPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _categoryController;
  late final TextEditingController _coverImageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.quiz.name);
    _descriptionController = TextEditingController(text: widget.quiz.description);
    _categoryController = TextEditingController(text: widget.quiz.category);
    _coverImageUrlController = TextEditingController(text: widget.quiz.coverImageUrl ?? '');
  }

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
          content: Text('You must be logged in to update a quiz'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = ref.read(updateQuizControllerProvider.notifier);
    controller.submit(
      quizId: widget.quiz.id,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _categoryController.text.trim(),
      coverImageUrl: _coverImageUrlController.text.trim().isEmpty
          ? null
          : _coverImageUrlController.text.trim(),
      userId: authState.user!.id,
      token: authState.token!,
      userRole: authState.roles.first,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(updateQuizControllerProvider);

    // Listen for successful update
    ref.listen(updateQuizControllerProvider, (previous, next) {
      if (next.success == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz updated successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        // Navigate back
        Navigator.pop(context);
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
        title: const Text('Edit Quiz'),
        elevation: 0,
      ),
      body: EditQuizForm(
        formKey: _formKey,
        nameController: _nameController,
        descriptionController: _descriptionController,
        categoryController: _categoryController,
        coverImageUrlController: _coverImageUrlController,
        onSubmit: _handleSubmit,
        loading: state.loading,
      ),
    );
  }
}