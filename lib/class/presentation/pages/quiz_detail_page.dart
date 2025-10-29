// class/presentation/pages/quiz_detail_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/quiz.dart';
import '../controllers/providers.dart' as class_providers;
import '../../../iam/presentation/controllers/providers.dart';
import 'question_form_page.dart';
import 'edit_quiz_page.dart';

class QuizDetailPage extends ConsumerStatefulWidget {
  final int quizId;

  const QuizDetailPage({super.key, required this.quizId});

  @override
  ConsumerState<QuizDetailPage> createState() => _QuizDetailPageState();
}

class _QuizDetailPageState extends ConsumerState<QuizDetailPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuiz();
    });
  }

  void _loadQuiz() {
    final authState = ref.read(authControllerProvider);
    if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
      ref.read(class_providers.quizDetailControllerProvider.notifier).loadQuiz(
            quizId: widget.quizId,
            userId: authState.user!.id,
            token: authState.token!,
            userRole: authState.roles.first,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final quizDetailState = ref.watch(class_providers.quizDetailControllerProvider);
    final Quiz? quiz = quizDetailState.quiz;
    final bool loading = quizDetailState.loading;
    final String? error = quizDetailState.error;

    // Show error snackbar if there's an error
    if (error != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $error'),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(class_providers.quizDetailControllerProvider.notifier).clearError();
              },
            ),
          ),
        );
        ref.read(class_providers.quizDetailControllerProvider.notifier).clearError();
      });
    }

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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : quiz == null
              ? const Center(child: Text('Quiz not found'))
              : _buildQuizContent(quiz),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addQuestion(),
        icon: const Icon(Icons.add),
        label: const Text('Add Question'),
      ),
    );
  }

  Widget _buildQuizContent(Quiz quiz) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quiz Header Card
          Card(
            margin: const EdgeInsets.all(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          quiz.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _buildStatusChip(quiz),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    quiz.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 16,
                    runSpacing: 8,
                    children: [
                      _buildInfoChip(Icons.category, quiz.category),
                      _buildInfoChip(Icons.question_answer, '${quiz.totalQuestions} questions'),
                      _buildInfoChip(Icons.stars, '${quiz.totalPoints} points'),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Questions Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Questions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          const SizedBox(height: 8),

          // Questions List
          if (quiz.questions.isEmpty)
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.quiz_outlined, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No questions yet',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Add your first question to get started!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: quiz.questions.length,
              itemBuilder: (context, index) {
                final question = quiz.questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${index + 1}'),
                    ),
                    title: Text(
                      question.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${question.answers.length} answers • ${question.points} pts • ${question.timeLimitSeconds}s',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            _editQuestion(question.id);
                            break;
                          case 'delete':
                            _deleteQuestion(question.id);
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
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(width: 8),
                              Text('Delete', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildStatusChip(Quiz quiz) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: quiz.isPublic ? Colors.green.shade100 : Colors.orange.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            quiz.isPublic ? Icons.public : Icons.lock,
            size: 16,
            color: quiz.isPublic ? Colors.green.shade700 : Colors.orange.shade700,
          ),
          const SizedBox(width: 4),
          Text(
            quiz.isPublic ? 'Public' : 'Private',
            style: TextStyle(
              fontSize: 12,
              color: quiz.isPublic ? Colors.green.shade700 : Colors.orange.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  void _addQuestion() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionFormPage(quizId: widget.quizId),
      ),
    ).then((_) => _loadQuiz());
  }

  void _editQuestion(int questionId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionFormPage(
          quizId: widget.quizId,
          questionId: questionId,
        ),
      ),
    ).then((_) => _loadQuiz());
  }

  void _deleteQuestion(int questionId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Question'),
        content: const Text('Are you sure you want to delete this question?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final authState = ref.read(authControllerProvider);
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication error'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              await ref.read(class_providers.questionFormControllerProvider.notifier).deleteQuestion(
                    quizId: widget.quizId,
                    questionId: questionId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!mounted) return;

              final questionState = ref.read(class_providers.questionFormControllerProvider);
              if (questionState.success) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Question deleted'), backgroundColor: Colors.green),
                );
                _loadQuiz();
              } else if (questionState.error != null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${questionState.error}'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog() {
    final quizDetailState = ref.read(class_providers.quizDetailControllerProvider);
    final currentQuiz = quizDetailState.quiz;

    if (currentQuiz == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Quiz not loaded'), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuizPage(quiz: currentQuiz),
      ),
    ).then((updated) {
      // Reload quiz if it was updated
      if (updated == true) {
        _loadQuiz();
      }
    });
  }

  void _publishQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Publish Quiz'),
        content: const Text('Make this quiz available to the public?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final authState = ref.read(authControllerProvider);
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication error'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              await ref.read(class_providers.quizDetailControllerProvider.notifier).publishQuiz(
                    quizId: widget.quizId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!mounted) return;

              final detailState = ref.read(class_providers.quizDetailControllerProvider);
              if (detailState.error == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz published!'), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${detailState.error}'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Publish'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Quiz'),
        content: const Text('Are you sure you want to delete this quiz? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final authState = ref.read(authControllerProvider);
              if (authState.user == null || authState.token == null || authState.roles.isEmpty) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Authentication error'), backgroundColor: Colors.red),
                  );
                }
                return;
              }

              await ref.read(class_providers.quizDetailControllerProvider.notifier).deleteQuiz(
                    quizId: widget.quizId,
                    userId: authState.user!.id,
                    token: authState.token!,
                    userRole: authState.roles.first,
                  );

              if (!mounted) return;

              final detailState = ref.read(class_providers.quizDetailControllerProvider);
              if (detailState.error == null) {
                Navigator.pop(context); // Go back to previous screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Quiz deleted'), backgroundColor: Colors.green),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${detailState.error}'), backgroundColor: Colors.red),
                );
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
