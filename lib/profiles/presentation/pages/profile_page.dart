import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/providers.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
    // Fetch the profile when the widget is first built.
    Future.microtask(() => ref.read(profileControllerProvider.notifier).fetchProfile());
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (profileState.loading)
              const CircularProgressIndicator()
            else if (profileState.error != null)
              Text('Error: ${profileState.error}')
            else if (profileState.profile != null)
              Column(
                children: [
                  Text('ID: ${profileState.profile!.id}'),
                  Text('Username: ${profileState.profile!.username}'),
                  Text('First Name: ${profileState.profile!.firstName}'),
                  Text('Last Name: ${profileState.profile!.lastName ?? 'N/A'}'),
                  Text('Profile URL: ${profileState.profile!.profileUrl ?? 'N/A'}'),
                ],
              )
            else
              const SizedBox.shrink(), // Show nothing if there's no profile and not loading
          ],
        ),
      ),
    );
  }
}