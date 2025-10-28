import 'package:flutter/material.dart';

class SaveProfileButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const SaveProfileButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: isLoading ? null : onPressed,
      icon: const Icon(Icons.save_alt_outlined, color: Colors.white),
      label: isLoading
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text('Save Changes', style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}