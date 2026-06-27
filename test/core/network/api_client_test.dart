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

  // 각 테스트 전에 Dio, MockStorage, ApiClient 초기화
  // Initialize Dio, MockStorage, and ApiClient before each test
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
  // 인증 / AuthInterceptor 테스트
  // Authentication / AuthInterceptor tests
  // ---------------------------------------------------------------------------
  group('AuthInterceptor', () {
    // 인증 요청 시 Bearer 토큰이 헤더에 추가되는지 확인
    // Verify Bearer token is attached to header for authenticated requests
    test('attaches Bearer token when authenticated is true', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'test-token');

      // AuthInterceptor가 설정한 헤더를 캡처
      // Capture the header set by AuthInterceptor
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

    // 비인증 요청 시 토큰이 헤더에 추가되지 않는지 확인
    // Verify token is NOT attached for unauthenticated requests
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

    // 저장된 토큰이 없으면 401 ApiException을 던지는지 확인
    // Verify 401 ApiException is thrown when no token is stored
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
  // 에러 처리 테스트
  // Error handling tests
  // ---------------------------------------------------------------------------
  group('Error handling', () {
    // 서버 에러 상태 코드가 ApiException으로 변환되는지 확인
    // Verify server error status codes are converted to ApiException
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

    // 서버 에러 시 에러 인터셉터 체인이 호출되는지 확인
    // Verify error interceptor chain is invoked on server error
    test('error interceptor chain is invoked on server error '
        '(CrashlyticsInterceptor records errors in production)', () async {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');

      // CrashlyticsInterceptor가 하는 것을 시뮬레이션: 서버 에러 시 인터셉터 체인 호출 검증
      // Simulates CrashlyticsInterceptor: verifies interceptor chain is called on server error
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

    // 알 수 없는 에러 시 statusCode 0인 ApiException 반환 확인
    // Verify ApiException with statusCode 0 is returned for unknown errors
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
  // HTTP 메서드 — GET 테스트
  // HTTP methods — GET tests
  // ---------------------------------------------------------------------------
  group('get', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    // 응답이 올바르게 파싱되는지 확인
    // Verify response is parsed correctly
    test('returns parsed response', () async {
      dioAdapter.onGet(
        '/books',
        (server) => server.reply(200, {'title': 'Test Book'}),
      );

      final result = await apiClient.get('/books');
      expect(result, {'title': 'Test Book'});
    });

    // 쿼리 파라미터가 올바르게 전달되는지 확인
    // Verify query parameters are passed correctly
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
  // HTTP 메서드 — POST 테스트
  // HTTP methods — POST tests
  // ---------------------------------------------------------------------------
  group('post', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    // 요청 body를 전송하고 응답이 올바르게 파싱되는지 확인
    // Verify body is sent and response is parsed correctly
    test('sends body and returns parsed response', () async {
      dioAdapter.onPost(
        '/books',
        (server) => server.reply(201, {'id': '1', 'title': 'New Book'}),
        data: Matchers.any,
      );

      final result = await apiClient.post('/books', {'title': 'New Book'});
      expect(result, {'id': '1', 'title': 'New Book'});
    });

    // 응답 body가 null이면 빈 Map을 반환하는지 확인
    // Verify empty map is returned when response body is null
    test('returns empty map for null response body', () async {
      dioAdapter.onPost(
        '/action',
        (server) => server.reply(201, null),
        data: Matchers.any,
      );

      final result = await apiClient.post('/action', {'key': 'value'});
      expect(result, <String, dynamic>{});
    });

    // 응답 body가 빈 문자열이면 빈 Map을 반환하는지 확인
    // Verify empty map is returned when response body is empty string
    test('returns empty map for empty string response body', () async {
      dioAdapter.onPost(
        '/action',
        (server) => server.reply(200, ''),
        data: Matchers.any,
      );

      final result = await apiClient.post('/action', {'key': 'value'});
      expect(result, <String, dynamic>{});
    });

    // 상태 코드가 successCodes에 없으면 ApiException을 던지는지 확인
    // Verify ApiException is thrown when status is not in successCodes
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
  // HTTP 메서드 — PATCH 테스트
  // HTTP methods — PATCH tests
  // ---------------------------------------------------------------------------
  group('patch', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    // 요청 body를 전송하고 응답이 올바르게 파싱되는지 확인
    // Verify body is sent and response is parsed correctly
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

    // 204 응답 시 빈 Map을 반환하는지 확인
    // Verify empty map is returned for 204 response
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
  // HTTP 메서드 — DELETE 테스트
  // HTTP methods — DELETE tests
  // ---------------------------------------------------------------------------
  group('delete', () {
    setUp(() {
      when(mockStorage.read(key: 'serverToken'))
          .thenAnswer((_) async => 'token');
    });

    // 응답이 올바르게 파싱되는지 확인
    // Verify response is parsed correctly
    test('returns parsed response', () async {
      dioAdapter.onDelete(
        '/books/1',
        (server) => server.reply(200, {'deleted': true}),
      );

      final result = await apiClient.delete('/books/1');
      expect(result, {'deleted': true});
    });

    // 204 응답 시 빈 Map을 반환하는지 확인
    // Verify empty map is returned for 204 response
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
