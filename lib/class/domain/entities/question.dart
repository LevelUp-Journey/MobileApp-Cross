// class/domain/entities/question.dart
import 'answer.dart';

class Question {
  final int id;
  final String content;
  final String contentType; // TEXT or IMAGE
  final String questionType; // MULTIPLE_CHOICE or TRUE_FALSE
  final int points;
  final int timeLimitSeconds;
  final int questionOrder;
  final List<Answer> answers;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Question({
    required this.id,
    required this.content,
    required this.contentType,
    required this.questionType,
    required this.points,
    required this.timeLimitSeconds,
    required this.questionOrder,
    required this.answers,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isMultipleChoice => questionType == 'MULTIPLE_CHOICE';
  bool get isTrueFalse => questionType == 'TRUE_FALSE';
  bool get isTextContent => contentType == 'TEXT';
  bool get isImageContent => contentType == 'IMAGE';

  List<Answer> get correctAnswers =>
      answers.where((answer) => answer.isCorrect).toList();

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Question && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
