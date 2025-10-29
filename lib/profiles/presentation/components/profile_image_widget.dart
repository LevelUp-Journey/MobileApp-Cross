import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../shared/models/avatar.dart';

class ProfileImageWidget extends StatefulWidget {
  final TextEditingController profileUrlController;

  const ProfileImageWidget({
    super.key,
    required this.profileUrlController,
  });

  @override
  State<ProfileImageWidget> createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  int _currentAvatarIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeAvatar();
    // Listen to controller changes to update avatar when API data loads
    widget.profileUrlController.addListener(_onProfileUrlChanged);
  }

  @override
  void dispose() {
    widget.profileUrlController.removeListener(_onProfileUrlChanged);
    super.dispose();
  }

  void _onProfileUrlChanged() {
    final currentUrl = widget.profileUrlController.text;
    if (currentUrl.isNotEmpty) {
      final avatar = Avatar.fromProfileUrl(currentUrl);
      if (avatar != null) {
        final newIndex = Avatar.available.indexOf(avatar);
        if (newIndex != _currentAvatarIndex) {
          setState(() {
            _currentAvatarIndex = newIndex;
          });
        }
      }
    }
  }

  void _initializeAvatar() {
    // Load avatar from API profileUrl
    final currentUrl = widget.profileUrlController.text;
    if (currentUrl.isNotEmpty) {
      final avatar = Avatar.fromProfileUrl(currentUrl);
      if (avatar != null) {
        _currentAvatarIndex = Avatar.available.indexOf(avatar);
      } else {
        // If URL doesn't match any avatar, default to first one
        _currentAvatarIndex = 0;
      }
    } else {
      // If no profileUrl from API, default to first avatar
      _currentAvatarIndex = 0;
    }
  }

  void _rotateAvatar() {
    setState(() {
      _currentAvatarIndex = (_currentAvatarIndex + 1) % Avatar.available.length;
      widget.profileUrlController.text = Avatar.available[_currentAvatarIndex].profileUrl;
    });
  }

  void _randomizeAvatar() {
    setState(() {
      final random = math.Random();
      _currentAvatarIndex = random.nextInt(Avatar.available.length);
      widget.profileUrlController.text = Avatar.available[_currentAvatarIndex].profileUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentAvatar = Avatar.available[_currentAvatarIndex];

    return Center(
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: ClipOval(
                  child: Image.asset(
                    currentAvatar.assetPath,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
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
                    icon: const Icon(Icons.shuffle, color: Colors.white, size: 20),
                    onPressed: _randomizeAvatar,
                    tooltip: 'Random avatar',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.navigate_before, size: 32),
                onPressed: () {
                  setState(() {
                    _currentAvatarIndex = (_currentAvatarIndex - 1 + Avatar.available.length) % Avatar.available.length;
                    widget.profileUrlController.text = Avatar.available[_currentAvatarIndex].profileUrl;
                  });
                },
              ),
              Text(
                currentAvatar.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.navigate_next, size: 32),
                onPressed: _rotateAvatar,
              ),
            ],
          ),
        ],
      ),
    );
  }
}