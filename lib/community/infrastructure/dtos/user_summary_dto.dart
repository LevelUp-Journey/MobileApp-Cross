// community/infrastructure/dtos/user_summary_dto.dart
import '../../domain/entities/user_summary.dart';

class UserSummaryDto {
  final String id;
  final String? displayName;
  final String? avatarUrl;

  const UserSummaryDto({
    required this.id,
    this.displayName,
    this.avatarUrl,
  });

  factory UserSummaryDto.fromJson(Map<String, dynamic> json) {
    return UserSummaryDto(
      id: json['id']?.toString() ?? '',
      displayName: json['displayName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        if (displayName != null) 'displayName': displayName,
        if (avatarUrl != null) 'avatarUrl': avatarUrl,
      };

  UserSummary toDomain() => UserSummary(
        id: id,
        displayName: displayName,
        avatarUrl: avatarUrl,
      );
}
