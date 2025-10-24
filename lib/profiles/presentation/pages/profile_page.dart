import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levelup_journey/shared/services/cloudinary_service.dart';

import '../../domain/entities/profile.dart';
import '../controllers/profile_state.dart';
import '../controllers/providers.dart';

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

  Future<void> _pickAndUploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final imageUrl = await _cloudinaryService.uploadImage(image.path);
        if (!mounted) return;
        setState(() {
          _profileUrlController.text = imageUrl;
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
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
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const SizedBox(height: 20),
                              Center(
                                child: Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 50,
                                      backgroundImage: _profileUrlController.text.isNotEmpty
                                          ? NetworkImage(_profileUrlController.text)
                                          : null,
                                      child: _profileUrlController.text.isEmpty
                                          ? const Icon(Icons.person, size: 50)
                                          : null,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      child: IconButton(
                                        icon: const Icon(Icons.camera_alt),
                                        onPressed: _pickAndUploadImage,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                  labelText: 'Username',
                                  prefixIcon: Icon(Icons.person_outline),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  prefixIcon: Icon(Icons.badge_outlined),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 30),
                              ElevatedButton.icon(
                                onPressed: profileState.loading ? null : _saveProfile,
                                icon: const Icon(Icons.save_alt_outlined),
                                label: profileState.loading
                                    ? const CircularProgressIndicator(color: Colors.white)
                                    : const Text('Save Changes'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(vertical: 15),
                                  textStyle: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const Text('No profile data.'),
      ),
    );
  }
}
