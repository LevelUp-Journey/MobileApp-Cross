// public/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../../iam/presentation/pages/login_page.dart';
import '../../../shared/components/appbar_widget.dart';
import '../../../shared/components/bottom_navigation_widget.dart';
import '../../../profiles/presentation/pages/profile_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  bool _isProfileMode = false;

  Widget _buildBody() {
    if (_isProfileMode) {
      return const ProfilePage(); // Use the profile page content
    }
    switch (_currentIndex) {
      case 0:
        return _homeBody();
      case 1:
        return _joinBody();
      case 2:
        return _communityBody();
      default:
        return _homeBody();
    }
  }

  Widget _homeBody() {
    final authState = ref.watch(authControllerProvider);
    final authNotifier = ref.read(authControllerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              size: 80,
            ),
            const SizedBox(height: 24),
            const Text(
              'Welcome!',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (authState.user != null) ...[
              Text(
                'User: ${authState.user!.email.value}',
                style: const TextStyle(
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'ID: ${authState.user!.id}',
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(height: 32),
            const Text(
              'You have successfully signed in',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                authNotifier.logout();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
              },
              child: const Text('Sign out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _joinBody() {
    return const Center(child: Text('Join Page'));
  }

  Widget _communityBody() {
    return const Center(child: Text('Community Page'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        leading: _isProfileMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _isProfileMode = false),
              )
            : null,
        onLeadingTap: _isProfileMode ? null : () => setState(() => _isProfileMode = true),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            _isProfileMode = false; // Reset profile mode when navigating
          });
        },
      ),
    );
  }
}