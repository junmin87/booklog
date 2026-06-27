import 'package:book_log/core/error/api_exception.dart';
import 'package:book_log/core/network/api_client.dart';
import 'package:book_log/feature/auth/data/auth_repository.dart';
import 'package:book_log/feature/auth/domain/entity/auth_user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'auth_repository_test.mocks.dart';

@GenerateMocks([ApiClient, FlutterSecureStorage])
void main() {
  late MockApiClient mockApiClient;
  late MockFlutterSecureStorage mockStorage;
  late AuthRepository repo;

  // 각 테스트 전에 Mock 객체와 AuthRepository 초기화
  // Initialize mock objects and AuthRepository before each test
  setUp(() {
    mockApiClient = MockApiClient();
    mockStorage = MockFlutterSecureStorage();
    repo = AuthRepository(
      apiClient: mockApiClient,
      storage: mockStorage,
    );
  });

  // ---------------------------------------------------------------------------
  // 토큰 유효성 검증 테스트
  // Token validation tests
  // ---------------------------------------------------------------------------
  group('validateToken', () {
    // 200 응답 시 true 반환 확인
    // Verify true is returned on 200 response
    test('returns true on 200', () async {
      when(mockApiClient.post(
        '/validate-token',
        {},
        authenticated: true,
        successCodes: [200],
      )).thenAnswer((_) async => <String, dynamic>{});

      final result = await repo.validateToken('token');
      expect(result, isTrue);
    });

    // 401 에러 시 false 반환 확인
    // Verify false is returned on 401 error
    test('returns false on 401 ApiException', () async {
      when(mockApiClient.post(
        '/validate-token',
        {},
        authenticated: true,
        successCodes: [200],
      )).thenThrow(const ApiException(statusCode: 401, message: 'Unauthorized'));

      final result = await repo.validateToken('token');
      expect(result, isFalse);
    });

    // 403 에러 시 false 반환 확인
    // Verify false is returned on 403 error
    test('returns false on 403 ApiException', () async {
      when(mockApiClient.post(
        '/validate-token',
        {},
        authenticated: true,
        successCodes: [200],
      )).thenThrow(const ApiException(statusCode: 403, message: 'Forbidden'));

      final result = await repo.validateToken('token');
      expect(result, isFalse);
    });

    // 401/403 외의 에러는 그대로 다시 던지는지 확인
    // Verify other errors are rethrown as-is
    test('rethrows on other ApiException', () async {
      when(mockApiClient.post(
        '/validate-token',
        {},
        authenticated: true,
        successCodes: [200],
      )).thenThrow(const ApiException(statusCode: 500, message: 'Server error'));

      expect(
        () => repo.validateToken('token'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // 사용자 정보 조회 테스트
  // User profile fetch tests
  // ---------------------------------------------------------------------------
  group('getMe', () {
    final meResponse = <String, dynamic>{
      'id': 'user-1',
      'email': 'test@example.com',
      'countryCode': 'KR',
      'languageCode': 'ko',
      'plan': 'premium',
      'snsType': 'apple',
      'snsId': 'apple-123',
    };

    // 성공 시 AuthUser 객체 반환 확인
    // Verify AuthUser is returned on success
    test('returns AuthUser on success', () async {
      when(mockApiClient.get('/user/me')).thenAnswer((_) async => meResponse);

      final user = await repo.getMe('token');

      expect(user, isNotNull);
      expect(user!.id, 'user-1');
      expect(user.email, 'test@example.com');
      expect(user.countryCode, 'KR');
      expect(user.languageCode, 'ko');
      expect(user.plan, 'premium');
      expect(user.snsType, 'apple');
      expect(user.snsId, 'apple-123');
    });

    // 401 에러 시 null 반환 확인
    // Verify null is returned on 401 error
    test('returns null on 401 ApiException', () async {
      when(mockApiClient.get('/user/me'))
          .thenThrow(const ApiException(statusCode: 401, message: 'Unauthorized'));

      final user = await repo.getMe('token');
      expect(user, isNull);
    });

    // 403 에러 시 null 반환 확인
    // Verify null is returned on 403 error
    test('returns null on 403 ApiException', () async {
      when(mockApiClient.get('/user/me'))
          .thenThrow(const ApiException(statusCode: 403, message: 'Forbidden'));

      final user = await repo.getMe('token');
      expect(user, isNull);
    });

    // 401/403 외의 에러는 그대로 다시 던지는지 확인
    // Verify other errors are rethrown as-is
    test('rethrows on other ApiException', () async {
      when(mockApiClient.get('/user/me'))
          .thenThrow(const ApiException(statusCode: 500, message: 'Server error'));

      expect(
        () => repo.getMe('token'),
        throwsA(isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500)),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // FCM 토큰 등록 테스트
  // FCM token registration tests
  // ---------------------------------------------------------------------------
  group('registerFcmToken', () {
    // 저장된 토큰이 없으면 API 호출을 건너뛰는지 확인
    // Verify API call is skipped when no stored token exists
    test('skips API call when no stored token', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => null);

      await repo.registerFcmToken('fcm-abc');

      verifyNever(mockApiClient.post(any, any));
    });

    // 토큰이 있으면 올바른 body로 POST 호출 확인
    // Verify POST is called with correct body when token exists
    test('calls POST with correct body when token exists', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'stored-token');
      when(mockApiClient.post('/user/fcm-token', {'fcm_token': 'fcm-abc'}))
          .thenAnswer((_) async => <String, dynamic>{});

      await repo.registerFcmToken('fcm-abc');

      verify(mockApiClient.post('/user/fcm-token', {'fcm_token': 'fcm-abc'}))
          .called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // FCM 토큰 삭제 테스트
  // FCM token deletion tests
  // ---------------------------------------------------------------------------
  group('deleteFcmToken', () {
    // 저장된 토큰이 없으면 API 호출을 건너뛰는지 확인
    // Verify API call is skipped when no stored token exists
    test('skips API call when no stored token', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => null);

      await repo.deleteFcmToken();

      verifyNever(mockApiClient.delete(any));
    });

    // 토큰이 있으면 DELETE 호출 확인
    // Verify DELETE is called when token exists
    test('calls DELETE when token exists', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'stored-token');
      when(mockApiClient.delete('/user/fcm-token'))
          .thenAnswer((_) async => <String, dynamic>{});

      await repo.deleteFcmToken();

      verify(mockApiClient.delete('/user/fcm-token')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // 국가 저장 테스트
  // Save country tests
  // ---------------------------------------------------------------------------
  group('saveCountry', () {
    // 올바른 body로 POST 호출 확인
    // Verify POST is called with correct body
    test('calls POST with correct body', () async {
      when(mockApiClient.post('/user/country', {
        'country_code': 'KR',
        'language_code': 'ko',
      })).thenAnswer((_) async => <String, dynamic>{});

      await repo.saveCountry('KR', 'ko');

      verify(mockApiClient.post('/user/country', {
        'country_code': 'KR',
        'language_code': 'ko',
      })).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // Apple 계정 삭제 테스트
  // Delete Apple account tests
  // ---------------------------------------------------------------------------
  group('deleteAppleAccount', () {
    // DELETE 호출 확인
    // Verify DELETE is called
    test('calls DELETE', () async {
      when(mockApiClient.delete('/user/apple'))
          .thenAnswer((_) async => <String, dynamic>{});

      await repo.deleteAppleAccount();

      verify(mockApiClient.delete('/user/apple')).called(1);
    });
  });
}
