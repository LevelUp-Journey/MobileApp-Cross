// class/domain/value_objects/quiz_name.dart
class QuizName {
  final String value;

  QuizName._(this.value);

  factory QuizName(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Quiz name cannot be empty');
    }
    if (trimmed.length < 3) {
      throw ArgumentError('Quiz name must be at least 3 characters long');
    }
    if (trimmed.length > 100) {
      throw ArgumentError('Quiz name must not exceed 100 characters');
    }
    return QuizName._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is QuizName && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
