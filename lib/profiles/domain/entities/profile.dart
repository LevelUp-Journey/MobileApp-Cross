class Profile {
  final String id;
  final String username;
  final String? profileUrl;
  final String firstName;
  final String? lastName;

  Profile({
    required this.id,
    required this.username,
    this.profileUrl,
    required this.firstName,
    this.lastName,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'],
      username: json['username'],
      profileUrl: json['profileUrl'],
      firstName: json['firstName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'profileUrl': profileUrl,
      'firstName': firstName,
      'lastName': lastName,
    };
  }
}
