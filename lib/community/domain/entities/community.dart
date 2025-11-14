// community/domain/entities/community.dart
class Community {
  final String id;
  final String ownerId;
  final String ownerProfileId;
  final String name;
  final String description;
  final String? imageUrl;
  final DateTime createdAt;
  final int? followerCount;

  const Community({
    required this.id,
    required this.ownerId,
    required this.ownerProfileId,
    required this.name,
    required this.description,
    this.imageUrl,
    required this.createdAt,
    this.followerCount,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Community && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
