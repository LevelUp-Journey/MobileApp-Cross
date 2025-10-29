// class/presentation/widgets/primary_button.dart
import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool loading;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.loading = false,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: loading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      );
    }

    return ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: loading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
    );
  }
}
