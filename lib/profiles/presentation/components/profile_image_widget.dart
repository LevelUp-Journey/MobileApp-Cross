import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImageWidget extends StatefulWidget {
  final TextEditingController profileUrlController;
  final ImagePicker picker;

  const ProfileImageWidget({
    super.key,
    required this.profileUrlController,
    required this.picker,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  Future<void> _pickAndUploadImage() async {
    final XFile? image = await widget.picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Image picked, but upload functionality removed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.black12,
            backgroundImage: widget.profileUrlController.text.isNotEmpty
                ? NetworkImage(widget.profileUrlController.text)
                : null,
            child: widget.profileUrlController.text.isEmpty
                ? const Icon(Icons.person, size: 50, color: Colors.black)
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                onPressed: _pickAndUploadImage,
              ),
            ),
          ),
        ],
      ),
    );
  }
}