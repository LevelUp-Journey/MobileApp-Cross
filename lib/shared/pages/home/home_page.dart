// public/pages/home/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../iam/presentation/controllers/providers.dart';
import '../../../iam/presentation/pages/login_page.dart';
import '../../components/appbar_widget.dart';
import '../../components/bottom_navigation_widget.dart';
import '../../../profiles/presentation/pages/profile_page.dart';
import '../../../class/presentation/pages/class_page.dart';
import '../../../community/presentation/pages/community_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;
  bool _isProfileMode = false;
  bool _isSettingsMode = false;

  Widget _buildBody() {
    if (_isProfileMode) {
      return const ProfilePage(); // Use the profile page content
    }
    if (_isSettingsMode) {
      return _settingsBody();
    }
    switch (_currentIndex) {
      case 0:
        return _homeBody();
      case 1:
        return const ClassPage();
      case 2:
        return const CommunityPage();
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
              const SizedBox(height: 8),
              if (authState.roles.isNotEmpty) ...[
                Text(
                  'Roles: ${authState.roles.join(", ")}',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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

  Widget _settingsBody() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Application Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          // Here you can add configuration options
          Text('Coming soon: Theme, Language, Notifications, etc.'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HeaderWidget(
        leading: _isProfileMode || _isSettingsMode
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() {
                  _isProfileMode = false;
                  _isSettingsMode = false;
                }),
              )
            : null,
        onLeadingTap: (_isProfileMode || _isSettingsMode) ? null : () => setState(() => _isSettingsMode = true),
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationWidget(
        currentIndex: _currentIndex,
        onTap: (i) {
          setState(() {
            _currentIndex = i;
            _isProfileMode = false; // Reset profile mode when navigating
            _isSettingsMode = false; // Reset settings mode when navigating
          });
        },
      ),
    );
  }
}