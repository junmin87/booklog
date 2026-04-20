import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/auth_user.dart';

// Migration: Immutable state class replaces the separate _state/_user/_countryCode/_error fields on ChangeNotifier
// 불변 인증 상태 클래스 (ChangeNotifier의 개별 필드를 대체)
// Immutable auth state class (replaces separate fields on ChangeNotifier)
class AuthNotifierState {
  final AuthUser? user;
  final String? countryCode;
  final String? languageCode;
  final String? error;

  const AuthNotifierState({this.user, this.countryCode, this.languageCode, this.error});

  bool get isLoggedIn => user != null;
  bool get isCountrySelected => countryCode != null;

  AuthNotifierState copyWith({AuthUser? user, String? countryCode, String? languageCode, String? error}) {
    return AuthNotifierState(
      user: user ?? this.user,
      countryCode: countryCode ?? this.countryCode,
      languageCode: languageCode ?? this.languageCode,
      error: error ?? this.error,
    );
  }
}

// Migration: AsyncNotifier replaces ChangeNotifier; build() runs auto-login once on first ref access
// 인증 상태 관리 Notifier (자동 로그인, Apple 로그인, 로그아웃 등)
// Auth state notifier (handles auto-login, Apple sign-in, logout, etc.)
class AuthNotifier extends AsyncNotifier<AuthNotifierState> {
  StreamSubscription<String>? _tokenRefreshSub;

  @override
  Future<AuthNotifierState> build() async {
    ref.onDispose(() {
      _tokenRefreshSub?.cancel();
    });

    // Migration: build() replaces tryAutoLogin() called via addPostFrameCallback in LoginPage.initState
    // 자동 로그인 시도: 저장된 토큰이 유효하면 사용자 정보 로드
    // Auto-login: load user profile if stored token is valid
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.getStoredToken();
    if (token == null) return const AuthNotifierState();

    final isValid = await repo.validateToken(token);
    if (isValid) {
      final user = await repo.getMe(token);
      debugPrint('User : ${user.toString()}');
      _registerFcmToken();
      return AuthNotifierState(user: user, countryCode: user?.countryCode, languageCode: user?.languageCode);
    } else {
      await repo.deleteToken();
      return const AuthNotifierState();
    }
  }

  // Apple 로그인 → 토큰 저장 → 사용자 정보 로드 → 상태 업데이트
  // Apple sign-in → save token → load user profile → update state
  Future<void> signInWithApple() async {
    state = const AsyncValue.loading();
    try {
      debugPrint('🍎 [1] signInWithApple 시작');
      final repo = ref.read(authRepositoryProvider);

      debugPrint('🍎 [2] appleLogin 호출 전');
      final result = await repo.appleLogin();
      debugPrint('🍎 [3] appleLogin 완료: $result');

      await repo.saveToken(result['token'] as String);
      debugPrint('🍎 [4] 토큰 저장 완료');

      final token = result['token'] as String;
      final user = await repo.getMe(token);
      debugPrint('🍎 [5] getMe 완료: $user');

      state = AsyncValue.data(AuthNotifierState(
        user: user,
        countryCode: result['country_code'] as String?,
      ));
      debugPrint('🍎 [6] 상태 업데이트 완료');
      _registerFcmToken();
    } catch (e, stack) {
      debugPrint('🍎 [ERROR] $e');
      debugPrint('🍎 [STACK] $stack');
      state = const AsyncValue.data(
        AuthNotifierState(error: 'Login failed. Please try again.'),
      );
    }
  }

  // 국가/언어 코드 저장 후 상태 갱신
  // Save country/language code then update state
  Future<void> saveCountry(String countryCode, String languageCode) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.saveCountry(countryCode, languageCode);
      // Migration: copyWith + AsyncValue.data replaces field mutation + notifyListeners()
      final current = state.value ?? const AuthNotifierState();
      state = AsyncValue.data(current.copyWith(countryCode: countryCode, languageCode: languageCode));
    } catch (e) {
      debugPrint('국가 저장 오류: $e'); // Country save error
    }
  }

  // 로그아웃: FCM 토큰 삭제 → 서버 토큰 삭제 → 상태 초기화
  // Logout: delete FCM token → delete server token → reset state
  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).deleteFcmToken();
    } catch (e) {
      debugPrint('[FCM] 토큰 삭제 실패: $e'); // FCM token delete failed
    }
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    await ref.read(authRepositoryProvider).deleteToken();
    state = const AsyncValue.data(AuthNotifierState());
  }

  // Apple 계정 삭제: FCM 토큰 삭제 → 계정 삭제 → 토큰 삭제 → 상태 초기화
  // Delete Apple account: remove FCM token → delete account → delete token → reset state
  Future<void> deleteAppleAccount() async {
    final repo = ref.read(authRepositoryProvider);
    try {
      await repo.deleteFcmToken();
    } catch (e) {
      debugPrint('[FCM] 토큰 삭제 실패: $e'); // FCM token delete failed
    }
    _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    await repo.deleteAppleAccount();
    await repo.deleteToken();
    state = const AsyncValue.data(AuthNotifierState());
  }

  // FCM 토큰 등록 및 갱신 구독
  // Register FCM token and subscribe to token refresh events
  void _registerFcmToken() {
    Future<void>(() async {
      try {
        final pushService = ref.read(pushServiceProvider);
        final repo = ref.read(authRepositoryProvider);

        // 푸시 알림 권한 요청
        // Request push notification permission
        final granted = await pushService.requestPermission();
        if (!granted) return;

        // 현재 FCM 토큰을 서버에 등록
        // Register current FCM token with server
        final fcmToken = await pushService.getToken();
        if (fcmToken != null) {
          await repo.registerFcmToken(fcmToken);
        }

        // 토큰 갱신 시 자동으로 서버에 재등록
        // Auto-register with server when token refreshes
        _tokenRefreshSub?.cancel();
        _tokenRefreshSub = pushService.onTokenRefresh.listen((newToken) async {
          try {
            await repo.registerFcmToken(newToken);
          } catch (e) {
            debugPrint('[FCM] 토큰 갱신 등록 실패: $e'); // FCM token refresh registration failed
          }
        });
      } catch (e) {
        debugPrint('[FCM] 토큰 등록 실패: $e'); // FCM token registration failed
      }
    });
  }
}

// Migration: AsyncNotifierProvider declared globally; replaces ChangeNotifierProvider in main.dart MultiProvider
// 전역 인증 상태 Provider
// Global auth state provider
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthNotifierState>(AuthNotifier.new);
