import 'package:flutter/foundation.dart';

import '../../data/auth_repository.dart';
import '../../domain/entity/auth_user.dart';

enum AuthState { idle, loading, loggedIn }

class AuthProvider with ChangeNotifier {
  final AuthRepository _repository;

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
  // 저장된 serverToken 확인 → 서버 /validate-token 호출
  // 유효하면 loggedIn, 만료/없으면 idle 상태 유지

  Future<void> tryAutoLogin() async {
    final token = await _repository.getStoredToken();
    if (token == null) return;

    _setState(AuthState.loading);

    try {
      final user = await _repository.validateToken(token);
      if (user != null) {
        _user = user;
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

  // ── Apple 로그인 ──────────────────────────────────────
  // Repository에서 identityToken → 서버 교환 → accessToken 획득
  // 토큰 저장 후 바로 validate로 유저 정보 확정

  Future<void> signInWithApple() async {
    _error = null;
    _setState(AuthState.loading);

    try {
      final token = await _repository.appleLogin();
      await _repository.saveToken(token);

      final user = await _repository.validateToken(token);
      _user = user;
      _setState(AuthState.loggedIn);
    } catch (e) {
      debugPrint('Apple 로그인 오류: $e');
      _error = 'Login failed. Please try again.';
      _setState(AuthState.idle);
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
