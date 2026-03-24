import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../domain/entity/auth_user.dart';

// 서버 토큰 저장 키
const _kServerTokenKey = 'serverToken';

class AuthRepository {
  final _storage = const FlutterSecureStorage();

  String get _baseUrl => dotenv.env['BASE_URL']!;
  String get _validateUrl => dotenv.env['SERVER_TOKEN_VALIDATE']!;

  // ── 토큰 저장소 ─────────────────────────────────────

  Future<String?> getStoredToken() => _storage.read(key: _kServerTokenKey);

  Future<void> saveToken(String token) =>
      _storage.write(key: _kServerTokenKey, value: token);

  Future<void> deleteToken() => _storage.delete(key: _kServerTokenKey);

  // ── Apple 로그인 ─────────────────────────────────────
  // 1) 기기에서 Apple 인증 → identityToken / userIdentifier / authorizationCode 획득
  // 2) 서버 /apple/login 에 전송 → 서버가 accessToken 발급
  // 3) accessToken 반환 (저장은 Provider에서 처리)

  // Future<String> appleLogin() async {

  Future<Map<String, dynamic>> appleLogin() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    if (credential.identityToken == null || credential.userIdentifier == null) {
      throw Exception('Apple 인증 실패: 필수 필드 누락');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/apple/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identityToken': credential.identityToken,
        'userIdentifier': credential.userIdentifier,
        'authorizationCode': credential.authorizationCode,
        'email': credential.email,
      }),
    );

    // ✅ 핵심: body 디코딩
    final decoded = jsonDecode(response.body);
    debugPrint('statusCode: ${response.statusCode}');
    debugPrint('raw body: ${response.body}');
    debugPrint('decoded body: $decoded');


    if (response.statusCode != 200) {
      throw Exception('서버 로그인 실패: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;

    // 서버 응답에서 accessToken 키 이름은 실제 서버 구현에 맞게 변경하세요.
    // final token = data['accessToken'] as String?;

    final token = data['serverToken'] as String?;
    if (token == null) throw Exception('서버 응답에 accessToken 없음');
    final countryCode = data['country_code'] as String?;

    // return token;
    return {
      'token': token,
      'country_code': countryCode,
    };
  }


  // 서버 발급 토큰임
  // ── 토큰 유효성 검증 ─────────────────────────────────
  // POST /validate-token  →  200: 유효 (userId, email 반환) | 401/403: 만료
  //
  // Future<AuthUser?> validateToken(String token) async {
  //   final response = await http.post(
  //     Uri.parse(_validateUrl),
  //     headers: {
  //       'Authorization': 'Bearer $token',
  //       'Content-Type': 'application/json',
  //     },
  //   );
  //
  //   if (response.statusCode == 200) {
  //     final body = jsonDecode(response.body) as Map<String, dynamic>;
  //     return AuthUser(
  //       userId: body['userId'] as String,
  //       email: body['email'] as String?,
  //     );
  //   }
  //
  //   if (response.statusCode == 401 || response.statusCode == 403) {
  //     return null; // 만료 → 재로그인 필요
  //   }
  //
  //   throw Exception('토큰 검증 실패: ${response.statusCode}');
  // }

  Future<AuthUser?> validateToken(String token) async {
    final response = await http.post(
      Uri.parse(_validateUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return AuthUser(
        userId: body['userId'] as String,
        email: body['email'] as String?,
        countryCode: body['country_code'] as String?,
      );
    }

    if (response.statusCode == 401 || response.statusCode == 403) {
      return null;
    }

    throw Exception('토큰 검증 실패: ${response.statusCode}');
  }

  Future<void> saveCountry(String countryCode, String languageCode) async {
    final token = await getStoredToken();
    if (token == null) throw Exception('토큰 없음');

    final response = await http.post(
      Uri.parse('$_baseUrl/user/country'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'country_code': countryCode,
        'language_code': languageCode,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('국가 저장 실패: ${response.statusCode}');
    }
  }
}
