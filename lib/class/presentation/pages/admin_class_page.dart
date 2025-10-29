import 'package:flutter/material.dart';
import 'my_quizzes_page.dart';
import 'create_quiz_page.dart';
import '../widgets/admin_action_card.dart';

class ClassAdminPage extends StatelessWidget {
  const ClassAdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
                  AdminActionCard(
                    icon: Icons.add_circle,
                    title: 'Create Quiz',
                    subtitle: 'Start a new quiz',
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateQuizPage(),
                        ),
                      );
                    },
                  ),
                  AdminActionCard(
                    icon: Icons.quiz,
                    title: 'My Quizzes',
                    subtitle: 'View and manage',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyQuizzesPage(),
                        ),
                      );
                    },
                  ),
                  AdminActionCard(
                    icon: Icons.public,
                    title: 'Public Quizzes',
                    subtitle: 'Browse available',
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Public quizzes feature coming soon'),
                        ),
                      );
                    },
                  ),
                  AdminActionCard(
                    icon: Icons.play_circle,
                    title: 'Live Sessions',
                    subtitle: 'Start or join',
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Live sessions feature coming soon'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}