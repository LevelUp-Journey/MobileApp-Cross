// class/domain/value_objects/quiz_category.dart
class QuizCategory {
  final String value;

  QuizCategory._(this.value);

  factory QuizCategory(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      throw ArgumentError('Category cannot be empty');
    }
    if (trimmed.length > 50) {
      throw ArgumentError('Category must not exceed 50 characters');
    }
    return QuizCategory._(trimmed);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is QuizCategory && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => value;
}
