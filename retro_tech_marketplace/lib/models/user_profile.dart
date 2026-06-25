class UserProfile {
  const UserProfile({
    required this.displayName,
    required this.username,
    required this.email,
    required this.bio,
    required this.location,
    required this.sellerName,
    required this.preferredContact,
  });

  static const defaults = UserProfile(
    displayName: 'Retro Tech',
    username: '@retrotech',
    email: 'retro@tech.market',
    bio: 'Collect rare. Live timeless.',
    location: 'Kuala Lumpur',
    sellerName: 'RetroTech Collector',
    preferredContact: 'In-app message',
  );

  final String displayName;
  final String username;
  final String email;
  final String bio;
  final String location;
  final String sellerName;
  final String preferredContact;

  Map<String, Object?> toMap() {
    return {
      'id': 1,
      'displayName': displayName,
      'username': username,
      'email': email,
      'bio': bio,
      'location': location,
      'sellerName': sellerName,
      'preferredContact': preferredContact,
    };
  }

  factory UserProfile.fromMap(Map<String, Object?> map) {
    return UserProfile(
      displayName: map['displayName'] as String? ?? defaults.displayName,
      username: map['username'] as String? ?? defaults.username,
      email: map['email'] as String? ?? defaults.email,
      bio: map['bio'] as String? ?? defaults.bio,
      location: map['location'] as String? ?? defaults.location,
      sellerName: map['sellerName'] as String? ?? defaults.sellerName,
      preferredContact:
          map['preferredContact'] as String? ?? defaults.preferredContact,
    );
  }
}
