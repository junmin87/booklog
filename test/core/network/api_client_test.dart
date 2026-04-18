import 'package:book_log/core/error/api_exception.dart';
import 'package:book_log/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_client_test.mocks.dart';

@GenerateMocks([FlutterSecureStorage])
void main() {
  late Dio dio;
  late DioAdapter dioAdapter;
  late MockFlutterSecureStorage mockStorage;
  late ApiClient apiClient;

  setUp(() {
    dio = Dio(BaseOptions(baseUrl: 'https://test.example.com'));
    dioAdapter = DioAdapter(dio: dio);
    mockStorage = MockFlutterSecureStorage();
    apiClient = ApiClient(storage: mockStorage, dio: dio);
  });

  tearDown(() {
    dioAdapter.close();
  });

  // ---------------------------------------------------------------------------
  // Authentication / AuthInterceptor
  // ---------------------------------------------------------------------------
  group('AuthInterceptor', () {
    test('attaches Bearer token when authenticated is true', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'test-token');

      // Capture the header set by AuthInterceptor.
      String? capturedAuth;
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedAuth = options.headers['Authorization'] as String?;
          handler.next(options);
        },
      ));

      dioAdapter.onGet('/test', (server) => server.reply(200, {'ok': true}));

      await apiClient.get('/test');
      expect(capturedAuth, 'Bearer test-token');
    });

    test('does not attach token when authenticated is false', () async {
      String? capturedAuth;
      dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          capturedAuth = options.headers['Authorization'] as String?;
          handler.next(options);
        },
      ));

      dioAdapter.onGet('/test', (server) => server.reply(200, {'ok': true}));

      await apiClient.get('/test', authenticated: false);
      expect(capturedAuth, isNull);
      verifyNever(mockStorage.read(key: anyNamed('key')));
    });

    test('throws ApiException with 401 when no token is stored', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => null);

      expect(
        () => apiClient.get('/test'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 401)
              .having((e) => e.message, 'message', 'Not logged in'),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // Error handling
  // ---------------------------------------------------------------------------
  group('Error handling', () {
    test('converts server error status to ApiException', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');

      dioAdapter.onGet(
        '/error',
        (server) => server.reply(500, 'Internal Server Error'),
      );

      expect(
        () => apiClient.get('/error'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });

    test('error interceptor chain is invoked on server error '
        '(CrashlyticsInterceptor records errors in production)', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');

      // Simulates what CrashlyticsInterceptor does: verifies that the error
      // interceptor chain is invoked when the server returns an error status.
      bool errorInterceptorCalled = false;
      dio.interceptors.add(InterceptorsWrapper(
        onError: (error, handler) {
          errorInterceptorCalled = true;
          handler.next(error);
        },
      ));

      dioAdapter.onGet(
        '/fail',
        (server) => server.reply(503, 'Service Unavailable'),
      );

      try {
        await apiClient.get('/fail');
      } on ApiException {
        // expected
      }

      expect(errorInterceptorCalled, isTrue);
    });

    test('returns ApiException with statusCode 0 for unknown errors', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');

      dioAdapter.onGet(
        '/timeout',
        (server) => server.throws(
          0,
          DioException(
            requestOptions: RequestOptions(path: '/timeout'),
            type: DioExceptionType.connectionTimeout,
          ),
        ),
      );

      expect(
        () => apiClient.get('/timeout'),
        throwsA(
          isA<ApiException>()
              .having((e) => e.statusCode, 'statusCode', 0),
        ),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // HTTP methods — GET
  // ---------------------------------------------------------------------------
  group('get', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    test('returns parsed response', () async {
      dioAdapter.onGet(
        '/books',
        (server) => server.reply(200, {'title': 'Test Book'}),
      );

      final result = await apiClient.get('/books');
      expect(result, {'title': 'Test Book'});
    });

    test('passes query parameters', () async {
      dioAdapter.onGet(
        '/books',
        (server) => server.reply(200, {'results': <dynamic>[]}),
        queryParameters: {'q': 'flutter'},
      );

      final result = await apiClient.get(
        '/books',
        queryParameters: {'q': 'flutter'},
      );
      expect(result, {'results': <dynamic>[]});
    });
  });

  // ---------------------------------------------------------------------------
  // HTTP methods — POST
  // ---------------------------------------------------------------------------
  group('post', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    test('sends body and returns parsed response', () async {
      dioAdapter.onPost(
        '/books',
        (server) => server.reply(201, {'id': '1', 'title': 'New Book'}),
        data: Matchers.any,
      );

      final result = await apiClient.post('/books', {'title': 'New Book'});
      expect(result, {'id': '1', 'title': 'New Book'});
    });

    test('returns empty map for null response body', () async {
      dioAdapter.onPost(
        '/action',
        (server) => server.reply(201, null),
        data: Matchers.any,
      );

      final result = await apiClient.post('/action', {'key': 'value'});
      expect(result, <String, dynamic>{});
    });

    test('returns empty map for empty string response body', () async {
      dioAdapter.onPost(
        '/action',
        (server) => server.reply(200, ''),
        data: Matchers.any,
      );

      final result = await apiClient.post('/action', {'key': 'value'});
      expect(result, <String, dynamic>{});
    });

    test('throws ApiException when status is not in successCodes', () async {
      dioAdapter.onPost(
        '/books',
        (server) => server.reply(422, {'error': 'Validation failed'}),
        data: Matchers.any,
      );

      expect(
        () => apiClient.post('/books', {'title': ''}),
        throwsA(isA<ApiException>()),
      );
    });
  });

  // ---------------------------------------------------------------------------
  // HTTP methods — PATCH
  // ---------------------------------------------------------------------------
  group('patch', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    test('sends body and returns parsed response', () async {
      dioAdapter.onPatch(
        '/books/1',
        (server) => server.reply(200, {'id': '1', 'updated': true}),
        data: Matchers.any,
      );

      final result =
          await apiClient.patch('/books/1', body: {'title': 'Updated'});
      expect(result, {'id': '1', 'updated': true});
    });

    test('returns empty map for 204 response', () async {
      dioAdapter.onPatch(
        '/books/1',
        (server) => server.reply(204, ''),
        data: Matchers.any,
      );

      final result =
          await apiClient.patch('/books/1', body: {'title': 'Updated'});
      expect(result, <String, dynamic>{});
    });
  });

  // ---------------------------------------------------------------------------
  // HTTP methods — DELETE
  // ---------------------------------------------------------------------------
  group('delete', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    test('returns parsed response', () async {
      dioAdapter.onDelete(
        '/books/1',
        (server) => server.reply(200, {'deleted': true}),
      );

      final result = await apiClient.delete('/books/1');
      expect(result, {'deleted': true});
    });

    test('returns empty map for 204 response', () async {
      dioAdapter.onDelete(
        '/books/1',
        (server) => server.reply(204, null),
      );

      final result = await apiClient.delete('/books/1');
      expect(result, <String, dynamic>{});
    });
  });
}
