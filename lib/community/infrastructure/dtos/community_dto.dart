// community/infrastructure/dtos/community_dto.dart
import '../../domain/entities/community.dart';

class CommunityDto {
  final String id;
  final String ownerId;
  final String ownerProfileId;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int? followerCount;

  const CommunityDto({
    required this.id,
    required this.ownerId,
    required this.ownerProfileId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.followerCount,
  });

  factory CommunityDto.fromJson(Map<String, dynamic> json) {
    return CommunityDto(
      id: json['id']?.toString() ?? '',
      ownerId: json['ownerId']?.toString() ?? '',
      ownerProfileId: json['ownerProfileId']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      imageUrl: json['imageUrl'] as String?,
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0),
      followerCount: json['followerCount'] == null ? null : int.tryParse(json['followerCount'].toString()),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ownerId': ownerId,
        'ownerProfileId': ownerProfileId,
        'name': name,
        'description': description,
        'createdAt': createdAt.toIso8601String(),
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (followerCount != null) 'followerCount': followerCount,
      };

  Community toDomain() => Community(
        id: id,
        ownerId: ownerId,
        ownerProfileId: ownerProfileId,
        name: name,
        description: description,
        imageUrl: imageUrl,
        createdAt: createdAt,
        followerCount: followerCount,
      );
}
