// community/domain/requests/community_requests.dart
class CreateCommunityRequest {
  final String name;
  final String description;
  final String? imageUrl;

  const CreateCommunityRequest({
    required this.name,
    required this.description,
    this.imageUrl,
  });
}

class UpdateCommunityRequest {
  final String communityId;
  final String name;
  final String description;
  final String? imageUrl;

  const UpdateCommunityRequest({
    required this.communityId,
    required this.name,
    required this.description,
    this.imageUrl,
  });
}
