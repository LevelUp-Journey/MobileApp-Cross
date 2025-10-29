// class/presentation/pages/question_form_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../controllers/providers.dart';
import '../widgets/question_form_fields.dart';
import '../widgets/answer_options_manager.dart';

class QuestionFormPage extends ConsumerStatefulWidget {
  final int quizId;
  final int? questionId; // null if creating new question

  const QuestionFormPage({
    super.key,
    required this.quizId,
    this.questionId,
  });

  @override
  ConsumerState<QuestionFormPage> createState() => _QuestionFormPageState();
}

class _QuestionFormPageState extends ConsumerState<QuestionFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionTextController = TextEditingController();
  final _timeLimitController = TextEditingController(text: '30');
  final _pointsController = TextEditingController(text: '10');
  final _mediaUrlController = TextEditingController();

  String _questionType = 'MULTIPLE_CHOICE';
  final List<TextEditingController> _answerControllers = [];
  int _correctAnswerIndex = 0;
  bool _loadingQuestion = false;

  @override
  void initState() {
    super.initState();
    // Initialize with 4 answer options by default
    for (int i = 0; i < 4; i++) {
      _answerControllers.add(TextEditingController());
    }

    // If editing, load question data
    if (widget.questionId != null) {
      _loadQuestionData();
    }
  }

  Future<void> _loadQuestionData() async {
    setState(() {
      _loadingQuestion = true;
    });

    try {
      final authState = ref.read(authControllerProvider);
      if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
        throw Exception('Not authenticated');
      }

      final getQuestionUseCase = ref.read(getQuestionUseCaseProvider);
      final question = await getQuestionUseCase.execute(
        quizId: widget.quizId,
        questionId: widget.questionId!,
        userId: authState.user!.id,
        token: authState.token!,
        userRole: authState.roles.first,
      );

      // Populate controllers
      _questionTextController.text = question.content;
      _questionType = question.questionType;
      _timeLimitController.text = question.timeLimitSeconds.toString();
      _pointsController.text = question.points.toString();

      // Handle answers
      for (var controller in _answerControllers) {
        controller.dispose();
      }
      _answerControllers.clear();

      for (int i = 0; i < question.answers.length; i++) {
        final answer = question.answers[i];
        _answerControllers.add(TextEditingController(text: answer.content));
        if (answer.isCorrect) {
          _correctAnswerIndex = i;
        }
      }

      // If TRUE_FALSE, ensure it's set correctly
      if (_questionType == 'TRUE_FALSE' && _answerControllers.length == 2) {
        _answerControllers[0].text = 'True';
        _answerControllers[1].text = 'False';
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading question: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _loadingQuestion = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _questionTextController.dispose();
    _timeLimitController.dispose();
    _pointsController.dispose();
    _mediaUrlController.dispose();
    for (var controller in _answerControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addAnswerOption() {
    if (_answerControllers.length < 6) {
      setState(() {
        _answerControllers.add(TextEditingController());
      });
    }
  }

  void _removeAnswerOption(int index) {
    if (_answerControllers.length > 2) {
      setState(() {
        _answerControllers[index].dispose();
        _answerControllers.removeAt(index);
        if (_correctAnswerIndex >= _answerControllers.length) {
          _correctAnswerIndex = _answerControllers.length - 1;
        }
      });
    }
  }

  void _handleQuestionTypeChanged(String? value) {
    if (value != null) {
      setState(() {
        _questionType = value;
        if (_questionType == 'TRUE_FALSE' && _answerControllers.length != 2) {
          // Reset to 2 answers for True/False
          for (var c in _answerControllers) {
            c.dispose();
          }
          _answerControllers.clear();
          _answerControllers.add(TextEditingController(text: 'True'));
          _answerControllers.add(TextEditingController(text: 'False'));
          _correctAnswerIndex = 0;
        }
      });
    }
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authState = ref.read(authControllerProvider);
    if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must be logged in'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Collect answers
    final answers = _answerControllers
        .map((c) => c.text.trim())
        .where((text) => text.isNotEmpty)
        .toList();

    if (answers.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please provide at least 2 answers'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final controller = ref.read(questionFormControllerProvider.notifier);

    if (widget.questionId == null) {
      // Add new question
      await controller.addQuestion(
        quizId: widget.quizId,
        questionText: _questionTextController.text.trim(),
        questionType: _questionType,
        timeLimit: int.parse(_timeLimitController.text),
        points: int.parse(_pointsController.text),
        answers: answers,
        correctAnswerIndex: _correctAnswerIndex,
        mediaUrl: _mediaUrlController.text.trim().isEmpty ? null : _mediaUrlController.text.trim(),
        userId: authState.user!.id,
        token: authState.token!,
        userRole: authState.roles.first,
      );
    } else {
      // Update existing question
      await controller.updateQuestion(
        quizId: widget.quizId,
        questionId: widget.questionId!,
        questionText: _questionTextController.text.trim(),
        questionType: _questionType,
        timeLimit: int.parse(_timeLimitController.text),
        points: int.parse(_pointsController.text),
        answers: answers,
        correctAnswerIndex: _correctAnswerIndex,
        mediaUrl: _mediaUrlController.text.trim().isEmpty ? null : _mediaUrlController.text.trim(),
        userId: authState.user!.id,
        token: authState.token!,
        userRole: authState.roles.first,
      );
    }

    if (!mounted) return;

    final state = ref.read(questionFormControllerProvider);
    if (state.success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.questionId == null
              ? 'Question added successfully!'
              : 'Question updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.error}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.questionId != null;
    final questionFormState = ref.watch(questionFormControllerProvider);

    if (_loadingQuestion) {
      return Scaffold(
        appBar: AppBar(
          title: Text(isEditing ? 'Edit Question' : 'Add Question'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Question' : 'Add Question'),
      ),
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                QuestionFormFields(
                  questionTextController: _questionTextController,
                  timeLimitController: _timeLimitController,
                  pointsController: _pointsController,
                  mediaUrlController: _mediaUrlController,
                  questionType: _questionType,
                  onQuestionTypeChanged: _handleQuestionTypeChanged,
                ),
                const SizedBox(height: 24),
                AnswerOptionsManager(
                  answerControllers: _answerControllers,
                  correctAnswerIndex: _correctAnswerIndex,
                  onCorrectAnswerChanged: (index) {
                    setState(() {
                      _correctAnswerIndex = index;
                    });
                  },
                  onAddOption: _addAnswerOption,
                  onRemoveOption: _removeAnswerOption,
                ),
                const SizedBox(height: 24),
                // Submit Button
                ElevatedButton(
                  onPressed: questionFormState.loading ? null : _handleSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    isEditing ? 'Update Question' : 'Add Question',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          // Loading Overlay
          if (questionFormState.loading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
