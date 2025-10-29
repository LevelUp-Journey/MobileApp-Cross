// shared/models/avatar.dart
class Avatar {
  final String id;
  final String name;
  final String assetPath;

  const Avatar({required this.id, required this.name, required this.assetPath});

  // URL format: https://levelup.journey/avatars/{id}
  String get profileUrl => 'https://levelup.journey/avatars/$id';

  static const List<Avatar> available = [
    Avatar(id: 'axolotl', name: 'Axolotl', assetPath: 'assets/profile/Axolotl.png'),
    Avatar(id: 'beaver', name: 'Beaver', assetPath: 'assets/profile/Beaver.png'),
    Avatar(id: 'chameleon', name: 'Chameleon', assetPath: 'assets/profile/Chameleon.png'),
    Avatar(id: 'crab', name: 'Crab', assetPath: 'assets/profile/Crab.png'),
    Avatar(id: 'elephant', name: 'Elephant', assetPath: 'assets/profile/Elephant.png'),
    Avatar(id: 'llama', name: 'Llama', assetPath: 'assets/profile/Llama.png'),
    Avatar(id: 'penguin', name: 'Penguin', assetPath: 'assets/profile/Penguin.png'),
    Avatar(id: 'seal', name: 'Seal', assetPath: 'assets/profile/Seal.png'),
    Avatar(id: 'shark', name: 'Shark', assetPath: 'assets/profile/Shark.png'),
    Avatar(id: 'tiger', name: 'Tiger', assetPath: 'assets/profile/Tiger.png'),
  ];

  static Avatar? fromProfileUrl(String? url) {
    if (url == null || url.isEmpty) return null;

    // Extract ID from URL format: https://levelup.journey/avatars/{id}
    final uri = Uri.tryParse(url);
    if (uri == null) return null;

    final segments = uri.pathSegments;
    if (segments.length >= 2 && segments[segments.length - 2] == 'avatars') {
      final id = segments.last;
      try {
        return available.firstWhere((avatar) => avatar.id == id);
      } catch (e) {
        return null;
      }
    }

    return null;
  }

  static Avatar random() {
    final randomIndex = DateTime.now().millisecondsSinceEpoch % available.length;
    return available[randomIndex];
  }
}
