// iam/domain/value_objects/password.dart
class Password {
  final String value;
  Password._(this.value);
  factory Password(String raw) {
    if (raw.length < 8) throw ArgumentError('Password must be at least 8 characters');
    return Password._(raw);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Password && other.value == value;
  @override
  int get hashCode => value.hashCode;
}