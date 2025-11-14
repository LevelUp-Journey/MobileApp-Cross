// community/domain/entities/user_summary.dart
class UserSummary {
  final String id;
  final String? displayName;
  final String? avatarUrl;

  const UserSummary({
    required this.id,
    this.displayName,
    this.avatarUrl,
  });
}
