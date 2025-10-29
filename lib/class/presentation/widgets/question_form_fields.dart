// class/presentation/widgets/question_form_fields.dart
import 'package:flutter/material.dart';

class QuestionFormFields extends StatelessWidget {
  final TextEditingController questionTextController;
  final TextEditingController timeLimitController;
  final TextEditingController pointsController;
  final TextEditingController mediaUrlController;
  final String questionType;
  final ValueChanged<String?> onQuestionTypeChanged;

  const QuestionFormFields({
    super.key,
    required this.questionTextController,
    required this.timeLimitController,
    required this.pointsController,
    required this.mediaUrlController,
    required this.questionType,
    required this.onQuestionTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: questionTextController,
          decoration: const InputDecoration(
            labelText: 'Question Text',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Question text is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: timeLimitController,
                decoration: const InputDecoration(
                  labelText: 'Time Limit (seconds)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Time limit is required';
                  }
                  final seconds = int.tryParse(value);
                  if (seconds == null || seconds <= 0) {
                    return 'Enter a valid time limit';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                controller: pointsController,
                decoration: const InputDecoration(
                  labelText: 'Points',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Points are required';
                  }
                  final points = int.tryParse(value);
                  if (points == null || points <= 0) {
                    return 'Enter valid points';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: questionType,
          decoration: const InputDecoration(
            labelText: 'Question Type',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
              value: 'MULTIPLE_CHOICE',
              child: Text('Multiple Choice'),
            ),
            DropdownMenuItem(
              value: 'TRUE_FALSE',
              child: Text('True/False'),
            ),
          ],
          onChanged: onQuestionTypeChanged,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Question type is required';
            }
            return null;
          },
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: mediaUrlController,
          decoration: const InputDecoration(
            labelText: 'Media URL (optional)',
            border: OutlineInputBorder(),
            hintText: 'https://example.com/image.jpg',
          ),
        ),
      ],
    );
  }
}