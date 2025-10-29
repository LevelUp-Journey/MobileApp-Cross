// class/domain/entities/answer.dart
class Answer {
  final int id;
  final String content;
  final String contentType; // TEXT or IMAGE
  final bool isCorrect;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Answer({
    required this.id,
    required this.content,
    required this.contentType,
    required this.isCorrect,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTextContent => contentType == 'TEXT';
  bool get isImageContent => contentType == 'IMAGE';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Answer && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
