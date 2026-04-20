import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/error/api_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/entity/auth_user.dart';

// 서버 토큰 저장 키
// Key used to store the server token in secure storage
const _kServerTokenKey = 'serverToken';

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    FlutterSecureStorage? storage,
  })  : _apiClient = apiClient,
        _storage = storage ?? const FlutterSecureStorage();

  final ApiClient _apiClient;
  final FlutterSecureStorage _storage;

  // ── 토큰 저장소 ─────────────────────────────────────
  // ── Token storage ─────────────────────────────────

  // 저장된 서버 토큰 읽기
  // Read the stored server token
  Future<String?> getStoredToken() => _storage.read(key: _kServerTokenKey);

  // 서버 토큰 저장
  // Save the server token
  Future<void> saveToken(String token) =>
      _storage.write(key: _kServerTokenKey, value: token);

  // 서버 토큰 삭제
  // Delete the server token
  Future<void> deleteToken() => _storage.delete(key: _kServerTokenKey);

  // ── Apple 로그인 ─────────────────────────────────────
  // ── Apple Sign-In ─────────────────────────────────
  // 1) 기기에서 Apple 인증 → identityToken / userIdentifier / authorizationCode 획득
  // 1) Authenticate with Apple on device → get identityToken / userIdentifier / authorizationCode
  // 2) 서버 /apple/login 에 전송 → 서버가 accessToken 발급
  // 2) Send to server /apple/login → server issues accessToken
  // 3) accessToken 반환 (저장은 Provider에서 처리)
  // 3) Return accessToken (saving is handled by the Provider)

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

    // Apple 인증 필수 필드 확인
    // Verify required fields from Apple auth
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
    // Adjust the accessToken key name below to match your server response.
    final token = data['serverToken'] as String?;
    // 서버 응답에 토큰이 없으면 예외 발생
    // Throw if server response has no token
    if (token == null) throw Exception('서버 응답에 accessToken 없음');
    final countryCode = data['country_code'] as String?;

    return {
      'token': token,
      'country_code': countryCode,
    };
  }

  // 토큰 유효성 검증 (서버에 요청)
  // Validate token by calling the server
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

  // 현재 사용자 정보 조회
  // Fetch current user profile from server
  Future<AuthUser?> getMe(String token) async {
    try {
      final body = await _apiClient.get('/user/me');

      return AuthUser.fromJson(body);
    } on ApiException catch (e) {
      if (e.statusCode == 401 || e.statusCode == 403) return null;
      rethrow;
    }
  }

  // Apple 계정 삭제 요청
  // Request Apple account deletion from server
  Future<void> deleteAppleAccount() async {
    await _apiClient.delete('/user/apple');
  }

  // FCM 토큰을 서버에 등록
  // Register FCM token with the server
  Future<void> registerFcmToken(String fcmToken) async {
    final token = await getStoredToken();
    if (token == null) return;

    await _apiClient.post(
      '/user/fcm-token',
      {'fcm_token': fcmToken},  // fcmToken → fcm_token
    );
  }

  // 서버에서 FCM 토큰 삭제
  // Delete FCM token from server
  Future<void> deleteFcmToken() async {
    final token = await getStoredToken();
    if (token == null) return;

    await _apiClient.delete('/user/fcm-token');
  }

  // 국가 및 언어 코드를 서버에 저장
  // Save country and language code to server
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
