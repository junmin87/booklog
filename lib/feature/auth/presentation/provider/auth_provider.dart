import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/auth_user.dart';

// Migration: Immutable state class replaces the separate _state/_user/_countryCode/_error fields on ChangeNotifier
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
class AuthNotifier extends AsyncNotifier<AuthNotifierState> {
  @override
  Future<AuthNotifierState> build() async {
    // Migration: build() replaces tryAutoLogin() called via addPostFrameCallback in LoginPage.initState
    final repo = ref.read(authRepositoryProvider);
    final token = await repo.getStoredToken();
    if (token == null) return const AuthNotifierState();

    final isValid = await repo.validateToken(token);
    if (isValid) {
      final user = await repo.getMe(token);
      debugPrint('User : ${user.toString()}');
      return AuthNotifierState(user: user, countryCode: user?.countryCode, languageCode: user?.languageCode);
    } else {
      await repo.deleteToken();
      return const AuthNotifierState();
    }
  }

  // Future<void> signInWithApple() async {
  //   // Migration: state = AsyncValue.loading() replaces _setState(AuthState.loading) + notifyListeners()
  //   state = const AsyncValue.loading();
  //   try {
  //     final repo = ref.read(authRepositoryProvider);
  //     final result = await repo.appleLogin();
  //     await repo.saveToken(result['token'] as String);
  //     final token = result['token'] as String;
  //     final user = await repo.getMe(token);
  //     state = AsyncValue.data(AuthNotifierState(
  //       user: user,
  //       countryCode: result['country_code'] as String?,
  //     ));
  //   } catch (e) {
  //     debugPrint('Apple 로그인 오류: $e');
  //     state = const AsyncValue.data(
  //       AuthNotifierState(error: 'Login failed. Please try again.'),
  //     );
  //   }
  // }


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
    } catch (e, stack) {
      debugPrint('🍎 [ERROR] $e');
      debugPrint('🍎 [STACK] $stack');
      state = const AsyncValue.data(
        AuthNotifierState(error: 'Login failed. Please try again.'),
      );
    }
  }

  Future<void> saveCountry(String countryCode, String languageCode) async {
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.saveCountry(countryCode, languageCode);
      // Migration: copyWith + AsyncValue.data replaces field mutation + notifyListeners()
      final current = state.value ?? const AuthNotifierState();
      state = AsyncValue.data(current.copyWith(countryCode: countryCode, languageCode: languageCode));
    } catch (e) {
      debugPrint('국가 저장 오류: $e');
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).deleteToken();
    state = const AsyncValue.data(AuthNotifierState());
  }

  Future<void> deleteAppleAccount() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.deleteAppleAccount();
    await repo.deleteToken();
    state = const AsyncValue.data(AuthNotifierState());
  }
}

// Migration: AsyncNotifierProvider declared globally; replaces ChangeNotifierProvider in main.dart MultiProvider
final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, AuthNotifierState>(AuthNotifier.new);
