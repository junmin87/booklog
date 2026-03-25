import 'package:flutter/foundation.dart';

import '../../data/auth_repository.dart';
import '../../domain/entity/auth_user.dart';

enum AuthState { idle, loading, loggedIn }

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;

  String? _countryCode;
  String? get countryCode => _countryCode;
  bool get isCountrySelected => _countryCode != null;

  AuthState _state = AuthState.idle;
  AuthUser? _user;
  String? _error;

  AuthState get state => _state;
  bool get isLoggedIn => _state == AuthState.loggedIn;
  bool get isLoading => _state == AuthState.loading;
  AuthUser? get user => _user;
  String? get error => _error;

  AuthProvider(this._repository);

  // ── 앱 시작 시 자동 로그인 시도 ───────────────────────
  // 유효하면 loggedIn, 만료/없으면 idle 상태 유지

  Future<void> tryAutoLogin() async {
    final token = await _repository.getStoredToken();
    if (token == null) return;

    _setState(AuthState.loading);

    try {
      final isValid = await _repository.validateToken(token);
      if (isValid) {
        final AuthUser? user = await _repository.getMe(token);
        _user = user;
        _countryCode = user?.countryCode;
        debugPrint('User : ${user.toString()}');
        _setState(AuthState.loggedIn);
      } else {
        await _repository.deleteToken();
        _setState(AuthState.idle);
      }
    } catch (e) {
      debugPrint('자동 로그인 오류: $e');
      _setState(AuthState.idle);
    }
  }


  Future<void> signInWithApple() async {
    _error = null;
    _setState(AuthState.loading);

    try {
      final result = await _repository.appleLogin();
      await _repository.saveToken(result['token'] as String);

      final token = result['token'] as String;
      final user = await _repository.getMe(token);
      _user = user;
      _countryCode = result['country_code'] as String?;
      _setState(AuthState.loggedIn);
    } catch (e) {
      debugPrint('Apple 로그인 오류: $e');
      _error = 'Login failed. Please try again.';
      _setState(AuthState.idle);
    }
  }


  Future<void> saveCountry(String countryCode, String languageCode) async {
    try {
      await _repository.saveCountry(countryCode, languageCode);
      _countryCode = countryCode;
      notifyListeners();
    } catch (e) {
      debugPrint('국가 저장 오류: $e');
    }
  }

  // ── 로그아웃 ──────────────────────────────────────────

  Future<void> logout() async {
    await _repository.deleteToken();
    _user = null;
    _error = null;
    _setState(AuthState.idle);
  }

  void _setState(AuthState newState) {
    _state = newState;
    notifyListeners();
  }
}
