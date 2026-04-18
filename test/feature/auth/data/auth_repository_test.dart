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

  setUp(() {
    mockApiClient = MockApiClient();
    mockStorage = MockFlutterSecureStorage();
    repo = AuthRepository(
      apiClient: mockApiClient,
      storage: mockStorage,
    );
  });

  // ---------------------------------------------------------------------------
  // validateToken
  // ---------------------------------------------------------------------------
  group('validateToken', () {
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
  // getMe
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

    test('returns null on 401 ApiException', () async {
      when(mockApiClient.get('/user/me'))
          .thenThrow(const ApiException(statusCode: 401, message: 'Unauthorized'));

      final user = await repo.getMe('token');
      expect(user, isNull);
    });

    test('returns null on 403 ApiException', () async {
      when(mockApiClient.get('/user/me'))
          .thenThrow(const ApiException(statusCode: 403, message: 'Forbidden'));

      final user = await repo.getMe('token');
      expect(user, isNull);
    });

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
  // registerFcmToken
  // ---------------------------------------------------------------------------
  group('registerFcmToken', () {
    test('skips API call when no stored token', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => null);

      await repo.registerFcmToken('fcm-abc');

      verifyNever(mockApiClient.post(any, any));
    });

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
  // deleteFcmToken
  // ---------------------------------------------------------------------------
  group('deleteFcmToken', () {
    test('skips API call when no stored token', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => null);

      await repo.deleteFcmToken();

      verifyNever(mockApiClient.delete(any));
    });

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
  // saveCountry
  // ---------------------------------------------------------------------------
  group('saveCountry', () {
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
  // deleteAppleAccount
  // ---------------------------------------------------------------------------
  group('deleteAppleAccount', () {
    test('calls DELETE', () async {
      when(mockApiClient.delete('/user/apple'))
          .thenAnswer((_) async => <String, dynamic>{});

      await repo.deleteAppleAccount();

      verify(mockApiClient.delete('/user/apple')).called(1);
    });
  });
}
