import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levelup_journey/shared/services/cloudinary_service.dart';

import '../../domain/entities/profile.dart';
import '../controllers/profile_state.dart';
import '../controllers/providers.dart';
import '../components/profile_image_widget.dart';
import '../components/profile_form_widget.dart';
import '../components/save_profile_button.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _profileUrlController;

  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _profileUrlController = TextEditingController();

    Future.microtask(() => ref.read(profileControllerProvider.notifier).fetchProfile());
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _profileUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      final profileState = ref.read(profileControllerProvider);
      if (profileState.profile == null) return;

      final updatedProfile = Profile(
        id: profileState.profile!.id,
        username: _usernameController.text,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text.isEmpty ? null : _lastNameController.text,
        profileUrl: _profileUrlController.text.isEmpty ? null : _profileUrlController.text,
      );

      final profileController = ref.read(profileControllerProvider.notifier);
      await profileController.updateProfile(updatedProfile);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
      }
    }
  }

  void _initializeControllers(Profile profile) {
    _usernameController.text = profile.username;
    _firstNameController.text = profile.firstName;
    _lastNameController.text = profile.lastName ?? '';
    _profileUrlController.text = profile.profileUrl ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);

    ref.listen<ProfileState>(profileControllerProvider, (previous, next) {
      if (next.profile != null && (previous?.profile != next.profile)) {
        _initializeControllers(next.profile!);
      }
    });

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: profileState.loading && profileState.profile == null
            ? const CircularProgressIndicator()
            : profileState.error != null
                ? Text('Error: ${profileState.error}')
                : profileState.profile != null
                    ? SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            ProfileImageWidget(
                              profileUrlController: _profileUrlController,
                              picker: _picker,
                              cloudinaryService: _cloudinaryService,
                            ),
                            const SizedBox(height: 20),
                            ProfileFormWidget(
                              formKey: _formKey,
                              usernameController: _usernameController,
                              firstNameController: _firstNameController,
                              lastNameController: _lastNameController,
                            ),
                            const SizedBox(height: 30),
                            SaveProfileButton(
                              isLoading: profileState.loading,
                              onPressed: _saveProfile,
                            ),
                          ],
                        ),
                      )
                    : const Text('No profile data.'),
      ),
    );
  }
}
