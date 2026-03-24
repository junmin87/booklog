class AuthUser {
  final String userId;
  final String? email;
  final String? countryCode;

  const AuthUser({
    required this.userId,
    this.email,
    this.countryCode,
  });
}