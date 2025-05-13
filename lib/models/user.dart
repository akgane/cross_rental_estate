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

  factory AppUser.fromFirestore(Map<String, dynamic> data, String uid){
    return AppUser(
      uid: uid,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      language: data['language'] ?? 'en',
      theme: data['theme'] ?? 'ThemeMode.light',
      avatarUrl: data['avatar-url'] ?? 'https://randomuser.me/api/portraits/men/1.jpg',
      favoriteEstates: (data['favorite-estates'] as List<dynamic>).cast<String>() ?? []
    );
  }

  Map<String, dynamic> toFirestore(){
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