// iam/domain/value_objects/email.dart
class Email {
  final String value;
  Email._(this.value);
  factory Email(String raw) {
    final r = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!r.hasMatch(raw)) throw ArgumentError('Invalid email format');
    return Email._(raw);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Email && other.value == value;
  @override
  int get hashCode => value.hashCode;
}