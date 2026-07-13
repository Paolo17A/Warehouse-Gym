class AppUser {
  final String uid;
  final String email;
  final String accountType; // 'CLIENT', 'TRAINER', 'ADMIN'
  final bool accountInitialized;
  final String profileImageURL;

  const AppUser({
    required this.uid,
    required this.email,
    required this.accountType,
    required this.accountInitialized,
    required this.profileImageURL,
  });
}
