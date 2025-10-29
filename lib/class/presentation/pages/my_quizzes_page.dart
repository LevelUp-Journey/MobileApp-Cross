// class/presentation/pages/my_quizzes_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/providers.dart';
import '../../../iam/presentation/controllers/providers.dart';
import 'create_quiz_page.dart';
import '../widgets/my_quizzes_content.dart';

class MyQuizzesPage extends ConsumerStatefulWidget {
  const MyQuizzesPage({super.key});

  @override
  ConsumerState<MyQuizzesPage> createState() => _MyQuizzesPageState();
}

class _MyQuizzesPageState extends ConsumerState<MyQuizzesPage> {
  @override
  void initState() {
    super.initState();
    // Load quizzes after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadQuizzes();
    });
  }

  void _loadQuizzes() {
    final authState = ref.read(authControllerProvider);
    if (authState.user != null && authState.token != null && authState.roles.isNotEmpty) {
      ref.read(myQuizzesControllerProvider.notifier).loadQuizzes(
            userId: authState.user!.id,
            token: authState.token!,
            userRole: authState.roles.first,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Quizzes'),
        elevation: 0,
      ),
      body: const MyQuizzesContent(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateQuizPage(),
            ),
          );
          // Reload quizzes after returning from create page
          _loadQuizzes();
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Quiz'),
      ),
    );
  }
}
