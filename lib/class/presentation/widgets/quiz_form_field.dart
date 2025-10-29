// class/presentation/widgets/quiz_form_field.dart
import 'package:flutter/material.dart';

class QuizFormField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?) validator;
  final int? maxLength;
  final int? maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final bool alignLabelWithHint;

  const QuizFormField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    required this.validator,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.alignLabelWithHint = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        alignLabelWithHint: alignLabelWithHint,
      ),
      validator: validator,
      maxLength: maxLength,
      maxLines: maxLines,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
    );
  }
}