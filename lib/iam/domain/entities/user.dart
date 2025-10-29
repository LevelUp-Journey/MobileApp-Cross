// iam/domain/entities/user.dart
import '../value_objects/email.dart';

class User {
  final String id;
  final Email email;
  final String? token;
  final List<String> roles;

  const User({
    required this.id,
    required this.email,
    this.token,
    this.roles = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User && id == other.id && email == other.email;
  @override
  int get hashCode => Object.hash(id, email);
}