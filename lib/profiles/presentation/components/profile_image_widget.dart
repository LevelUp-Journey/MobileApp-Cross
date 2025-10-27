import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:levelup_journey/shared/services/cloudinary_service.dart';

class ProfileImageWidget extends StatefulWidget {
  final TextEditingController profileUrlController;
  final ImagePicker picker;
  final CloudinaryService cloudinaryService;

  const ProfileImageWidget({
    super.key,
    required this.profileUrlController,
    required this.picker,
    required this.cloudinaryService,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await widget.picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      try {
        final imageUrl = await widget.cloudinaryService.uploadImage(image.path);
        if (!mounted) return;
        setState(() {
          widget.profileUrlController.text = imageUrl;
        });
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: widget.profileUrlController.text.isNotEmpty
                ? NetworkImage(widget.profileUrlController.text)
                : null,
            child: widget.profileUrlController.text.isEmpty
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
    );
  }
}