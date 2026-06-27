import 'dart:async';

import 'package:book_log/app/di.dart';
import 'package:book_log/core/service/push_service.dart';
import 'package:book_log/feature/auth/data/auth_repository.dart';
import 'package:book_log/feature/auth/domain/entity/auth_user.dart';
import 'package:book_log/feature/auth/presentation/provider/auth_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([AuthRepository, PushService])
import 'auth_notifier_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockPushService mockPushService;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockPushService = MockPushService();

    // PushService 기본 스텁 (FCM 등록 실패 방지)
    // Default PushService stubs (prevent FCM registration failures)
    when(mockPushService.requestPermission())
        .thenAnswer((_) async => false);
    when(mockPushService.onTokenRefresh)
        .thenAnswer((_) => const Stream<String>.empty());
  });

  ProviderContainer createContainer() {
    return ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(mockAuthRepository),
        pushServiceProvider.overrideWithValue(mockPushService),
      ],
    );
  }

  /// Waits until the [authNotifierProvider] settles to data or error.
  Future<AuthNotifierState> waitForData(ProviderContainer container) async {
    // Read to trigger build, then wait until it's no longer loading.
    final sub = container.listen(authNotifierProvider, (_, __) {});
    await container.read(authNotifierProvider.future);
    final value = container.read(authNotifierProvider).value!;
    sub.close();
    return value;
  }

  // ──────────────────────────────────────────────────────────────
  // build()
  // ──────────────────────────────────────────────────────────────

  group('build()', () {
    // 저장된 토큰이 유효하면 로그인 상태를 반환한다
    // Returns logged-in state when stored token is valid
    test('returns logged-in state when stored token is valid and getMe succeeds',
        () async {
      final user = AuthUser(
        id: '1',
        email: 'test@test.com',
        countryCode: 'KR',
        languageCode: 'ko',
        snsType: 'apple',
        snsId: 'apple_123',
      );

      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => 'valid_token');
      when(mockAuthRepository.validateToken('valid_token'))
          .thenAnswer((_) async => true);
      when(mockAuthRepository.getMe('valid_token'))
          .thenAnswer((_) async => user);

      final container = createContainer();
      final state = await waitForData(container);

      expect(state.isLoggedIn, isTrue);
      expect(state.user, equals(user));
      expect(state.countryCode, equals('KR'));
      expect(state.languageCode, equals('ko'));

      container.dispose();
    });

    // 저장된 토큰이 없으면 빈 상태를 반환한다
    // Returns empty state when no token is stored
    test('returns empty state when no token is stored', () async {
      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => null);

      final container = createContainer();
      final state = await waitForData(container);

      expect(state.isLoggedIn, isFalse);
      expect(state.user, isNull);

      container.dispose();
    });

    // 저장된 토큰이 유효하지 않으면 토큰을 삭제하고 빈 상태를 반환한다
    // Deletes token and returns empty state when stored token is invalid
    test('deletes token and returns empty state when token is invalid',
        () async {
      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => 'expired_token');
      when(mockAuthRepository.validateToken('expired_token'))
          .thenAnswer((_) async => false);
      when(mockAuthRepository.deleteToken())
          .thenAnswer((_) async {});

      final container = createContainer();
      final state = await waitForData(container);

      expect(state.isLoggedIn, isFalse);
      expect(state.user, isNull);
      verify(mockAuthRepository.deleteToken()).called(1);

      container.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // signInWithApple()
  // ──────────────────────────────────────────────────────────────

  group('signInWithApple()', () {
    // Apple 로그인 성공 시 로그인 상태를 반환한다
    // Returns logged-in state on successful Apple sign-in
    test('sets logged-in state on success', () async {
      // build() 에서는 토큰 없음
      // No token during build()
      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => null);

      final user = AuthUser(
        id: '2',
        snsType: 'apple',
        snsId: 'apple_456',
      );

      when(mockAuthRepository.appleLogin()).thenAnswer(
        (_) async => {'token': 'new_token', 'country_code': 'US'},
      );
      when(mockAuthRepository.saveToken('new_token'))
          .thenAnswer((_) async {});
      when(mockAuthRepository.getMe('new_token'))
          .thenAnswer((_) async => user);

      final container = createContainer();
      await waitForData(container); // build 완료 대기 / wait for build

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithApple();

      final state = container.read(authNotifierProvider).value!;
      expect(state.isLoggedIn, isTrue);
      expect(state.user, equals(user));
      expect(state.countryCode, equals('US'));

      container.dispose();
    });

    // Apple 로그인 실패 시 에러 상태를 반환한다
    // Returns error state on Apple sign-in failure
    test('sets error state on failure', () async {
      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => null);
      when(mockAuthRepository.appleLogin())
          .thenThrow(Exception('Apple sign-in cancelled'));

      final container = createContainer();
      await waitForData(container);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.signInWithApple();

      final state = container.read(authNotifierProvider).value!;
      expect(state.isLoggedIn, isFalse);
      expect(state.error, equals('Login failed. Please try again.'));

      container.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // logout()
  // ──────────────────────────────────────────────────────────────

  group('logout()', () {
    // FCM 토큰 삭제, 서버 토큰 삭제, 상태 초기화를 수행한다
    // Calls deleteFcmToken, deletes token, and resets state
    test('calls deleteFcmToken, deletes token, and resets state', () async {
      final user = AuthUser(
        id: '1',
        snsType: 'apple',
        snsId: 'apple_123',
      );

      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => 'token');
      when(mockAuthRepository.validateToken('token'))
          .thenAnswer((_) async => true);
      when(mockAuthRepository.getMe('token'))
          .thenAnswer((_) async => user);
      when(mockAuthRepository.deleteFcmToken())
          .thenAnswer((_) async {});
      when(mockAuthRepository.deleteToken())
          .thenAnswer((_) async {});

      final container = createContainer();
      await waitForData(container);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.logout();

      verify(mockAuthRepository.deleteFcmToken()).called(1);
      verify(mockAuthRepository.deleteToken()).called(1);

      final state = container.read(authNotifierProvider).value!;
      expect(state.isLoggedIn, isFalse);
      expect(state.user, isNull);

      container.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // deleteAppleAccount()
  // ──────────────────────────────────────────────────────────────

  group('deleteAppleAccount()', () {
    // FCM 토큰 삭제, 계정 삭제, 서버 토큰 삭제, 상태 초기화를 수행한다
    // Calls deleteFcmToken, deletes account, deletes token, and resets state
    test(
        'calls deleteFcmToken, deleteAppleAccount, deleteToken, and resets state',
        () async {
      final user = AuthUser(
        id: '1',
        snsType: 'apple',
        snsId: 'apple_123',
      );

      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => 'token');
      when(mockAuthRepository.validateToken('token'))
          .thenAnswer((_) async => true);
      when(mockAuthRepository.getMe('token'))
          .thenAnswer((_) async => user);
      when(mockAuthRepository.deleteFcmToken())
          .thenAnswer((_) async {});
      when(mockAuthRepository.deleteAppleAccount())
          .thenAnswer((_) async {});
      when(mockAuthRepository.deleteToken())
          .thenAnswer((_) async {});

      final container = createContainer();
      await waitForData(container);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.deleteAppleAccount();

      verify(mockAuthRepository.deleteFcmToken()).called(1);
      verify(mockAuthRepository.deleteAppleAccount()).called(1);
      verify(mockAuthRepository.deleteToken()).called(1);

      final state = container.read(authNotifierProvider).value!;
      expect(state.isLoggedIn, isFalse);
      expect(state.user, isNull);

      container.dispose();
    });
  });

  // ──────────────────────────────────────────────────────────────
  // saveCountry()
  // ──────────────────────────────────────────────────────────────

  group('saveCountry()', () {
    // 국가/언어 코드로 상태를 업데이트한다
    // Updates state with new country and language code
    test('updates state with new country and language code', () async {
      final user = AuthUser(
        id: '1',
        snsType: 'apple',
        snsId: 'apple_123',
      );

      when(mockAuthRepository.getStoredToken())
          .thenAnswer((_) async => 'token');
      when(mockAuthRepository.validateToken('token'))
          .thenAnswer((_) async => true);
      when(mockAuthRepository.getMe('token'))
          .thenAnswer((_) async => user);
      when(mockAuthRepository.saveCountry('JP', 'ja'))
          .thenAnswer((_) async {});

      final container = createContainer();
      await waitForData(container);

      final notifier = container.read(authNotifierProvider.notifier);
      await notifier.saveCountry('JP', 'ja');

      verify(mockAuthRepository.saveCountry('JP', 'ja')).called(1);

      final state = container.read(authNotifierProvider).value!;
      expect(state.countryCode, equals('JP'));
      expect(state.languageCode, equals('ja'));

      container.dispose();
    });
  });
}
