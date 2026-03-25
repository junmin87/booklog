class AuthUser {
  final String id;
  final String? email;
  final String? countryCode;
  final String? languageCode;
  final String plan;
  final String snsType;
  final String snsId;

  const AuthUser({
    required this.id,
    this.email,
    this.countryCode,
    this.languageCode,
    this.plan = 'free',
    required this.snsType,
    required this.snsId,
  });

  @override
  String toString() {
    return 'AuthUser{id: $id, email: $email, countryCode: $countryCode, languageCode: $languageCode, plan: $plan, snsType: $snsType, snsId: $snsId}';
  }
}