class AppUser {
  final String uid;
  final String email;
  final String username;
  final String avatarUrl;
  late String language;
  late String theme;
  final List<String> favoriteEstates;

  AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.language = 'en',
    this.theme = 'ThemeMode.light',
    this.avatarUrl = 'https://avatar.iran.liara.run/username?username=?',
    this.favoriteEstates = const [],
  });

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid) {
    String themeStr = data['theme'] ?? 'ThemeMode.light';
    // Ensure theme string is in correct format
    if (themeStr == 'dark' || themeStr == 'ThemeMode.dark') {
      themeStr = 'ThemeMode.dark';
    } else {
      themeStr = 'ThemeMode.light';
    }

    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      language: data['language'] ?? 'en',
      theme: themeStr,
      avatarUrl: data['avatar-url'] ?? 'https://randomuser.me/api/portraits/men/1.jpg',
      favoriteEstates: (data['favorite-estates'] as List<dynamic>?)?.cast<String>() ?? []
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'language': language,
      'theme': theme,
      'avatar-url': avatarUrl,
      'favorite-estates': favoriteEstates
    };
  }
}