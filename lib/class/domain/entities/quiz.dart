// class/domain/entities/quiz.dart
import 'question.dart';

class Quiz {
  final int id;
  final String name;
  final String description;
  final String? coverImageUrl;
  final String category;
  final String visibility; // PRIVATE or PUBLIC
  final String creatorId;
  final List<Question> questions;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Quiz({
    required this.id,
    required this.name,
    required this.description,
    this.coverImageUrl,
    required this.category,
    required this.visibility,
    required this.creatorId,
    this.questions = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isPublic => visibility == 'PUBLIC';
  bool get isPrivate => visibility == 'PRIVATE';
  bool get isEmpty => questions.isEmpty;
  int get totalQuestions => questions.length;
  int get totalPoints => questions.fold(0, (sum, q) => sum + q.points);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Quiz && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
