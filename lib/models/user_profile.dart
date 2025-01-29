class UserProfile {
  final String name;
  final String email;
  final List<String> favoriteDestinations;

  UserProfile({
    required this.name,
    required this.email,
    this.favoriteDestinations = const [],
  });
}
