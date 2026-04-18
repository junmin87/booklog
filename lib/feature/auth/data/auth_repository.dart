import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/error/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/entity/auth_user.dart';

// 서버 토큰 저장 키
const _kServerTokenKey = 'serverToken';

class AuthRepository {
  AuthRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;
  final _storage = const FlutterSecureStorage();

  // ── 토큰 저장소 ─────────────────────────────────────

  Future<String?> getStoredToken() => _storage.read(key: _kServerTokenKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _kServerTokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _kServerTokenKey);

  // ── Apple 로그인 ─────────────────────────────────────
  // 1) 기기에서 Apple 인증 → identityToken / userIdentifier / authorizationCode 획득
  // 2) 서버 /apple/login 에 전송 → 서버가 accessToken 발급
  // 3) accessToken 반환 (저장은 Provider에서 처리)

  Future<Map<String, dynamic>> appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    debugPrint('🍎 [repo] credential 획득: ${credential.userIdentifier}');
    debugPrint('🍎 identityToken: ${credential.identityToken}');
    debugPrint('🍎 authorizationCode: ${credential.authorizationCode}');
    debugPrint('🍎 email: ${credential.email}');

    if (credential.identityToken == null || credential.userIdentifier == null) {
      throw Exception('Apple 인증 실패: 필수 필드 누락');
    }

    final data = await _apiClient.post(
      '/apple/login',
      {
        'identityToken': credential.identityToken,
        'userIdentifier': credential.userIdentifier,
        'authorizationCode': credential.authorizationCode,
        'email': credential.email,
      },
      authenticated: false,
    );

    // 서버 응답에서 accessToken 키 이름은 실제 서버 구현에 맞게 변경하세요.
    final token = data['serverToken'] as String?;
    if (token == null) throw Exception('서버 응답에 accessToken 없음');
    final countryCode = data['country_code'] as String?;

    return {
      'token': token,
      'country_code': countryCode,
    };
  }

  Future<bool> validateToken(String token) async {
    try {
      await _apiClient.post(
        // '/auth/validate',
        '/validate-token',
        {},
        // authenticated: false,
        authenticated: true,  //add token
        successCodes: [200],
      );
      return true;
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) return false;
      rethrow;
    }
  }

  Future<AuthUser?> getMe(String token) async {
    try {
      final body = await _apiClient.get('/user/me');

      return AuthUser(
        id: body['id'] as String,
        email: body['email'] as String?,
        countryCode: body['countryCode'] as String?,
        languageCode: body['languageCode'] as String?,
        plan: body['plan'] as String? ?? 'free',
        snsType: body['snsType'] as String,
        snsId: body['snsId'] as String,
      );
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) return null;
      rethrow;
    }
  }

  Future<void> deleteAppleAccount() async {
    await _apiClient.delete('/user/apple');
  }

  Future<void> registerFcmToken(String fcmToken) async {
    final token = await getStoredToken();
    if (token == null) return;

    await _apiClient.post(
      '/user/fcm-token',
      {'fcm_token': fcmToken},  // fcmToken → fcm_token
    );
  }

  Future<void> deleteFcmToken() async {
    final token = await getStoredToken();
    if (token == null) return;

    await _apiClient.delete('/user/fcm-token');
  }

  Future<void> saveCountry(String countryCode, String languageCode) async {
    await _apiClient.post(
      '/user/country',
      {
        'country_code': countryCode,
        'language_code': languageCode,
      },
    );
  }
}
