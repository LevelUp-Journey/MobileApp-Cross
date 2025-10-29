// class/presentation/widgets/answer_options_manager.dart
import 'package:flutter/material.dart';

class AnswerOptionsManager extends StatefulWidget {
  final List<TextEditingController> answerControllers;
  final int correctAnswerIndex;
  final ValueChanged<int> onCorrectAnswerChanged;
  final VoidCallback onAddOption;
  final Function(int) onRemoveOption;

  const AnswerOptionsManager({
    super.key,
    required this.answerControllers,
    required this.correctAnswerIndex,
    required this.onCorrectAnswerChanged,
    required this.onAddOption,
    required this.onRemoveOption,
  });

  @override
  State<AnswerOptionsManager> createState() => _AnswerOptionsManagerState();
}

class _AnswerOptionsManagerState extends State<AnswerOptionsManager> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Answer Options',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...List.generate(widget.answerControllers.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: widget.answerControllers[index],
                    decoration: InputDecoration(
                      labelText: 'Answer ${index + 1}',
                      border: const OutlineInputBorder(),
                      suffixIcon: Radio<int>(
                        value: index,
                        groupValue: widget.correctAnswerIndex,
                        onChanged: (value) {
                          if (value != null) {
                            widget.onCorrectAnswerChanged(value);
                          }
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Answer cannot be empty';
                      }
                      return null;
                    },
                  ),
                ),
                if (widget.answerControllers.length > 2)
                  IconButton(
                    onPressed: () => widget.onRemoveOption(index),
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
              ],
            ),
          );
        }),
        if (widget.answerControllers.length < 6)
          ElevatedButton.icon(
            onPressed: widget.onAddOption,
            icon: const Icon(Icons.add),
            label: const Text('Add Answer Option'),
          ),
        const SizedBox(height: 16),
        Text(
          'Correct Answer: Option ${widget.correctAnswerIndex + 1}',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}