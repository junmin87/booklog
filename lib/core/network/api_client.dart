import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../error/api_exception.dart';

// 서버 토큰 저장 키
// Key used to store the server token in secure storage
const _kServerTokenKey = 'serverToken';

// HTTP 클라이언트 래퍼 (Dio 기반)
// HTTP client wrapper built on Dio
class ApiClient {
  // 생성자: 보안 저장소와 Dio 인스턴스 초기화
  // Constructor: initializes secure storage and Dio instance
  ApiClient({FlutterSecureStorage? storage, @visibleForTesting Dio? dio})
      : _storage = storage ?? const FlutterSecureStorage() {
    _dio = dio ??
        Dio(BaseOptions(
          baseUrl: dotenv.env['BASE_URL']!,
          contentType: 'application/json',
        ));

    // 토큰 자동 주입 인터셉터 추가
    // Add interceptor that auto-injects auth token
    _dio.interceptors.add(_AuthInterceptor(_storage));
    // 테스트 시에는 Crashlytics 인터셉터 생략
    // Skip Crashlytics interceptor during tests
    if (dio == null) {
      _dio.interceptors.add(_CrashlyticsInterceptor());
    }
  }

  final FlutterSecureStorage _storage;
  late final Dio _dio;

  // GET 요청
  // Sends a GET request
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) {
    return _execute(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        path,
        queryParameters: queryParameters,
        options: Options(extra: {'authenticated': authenticated}),
      );
      return response.data!;
    });
  }

  // POST 요청
  // Sends a POST request
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = true,
    List<int> successCodes = const [200, 201],
  }) {
    return _execute(() async {
      final response = await _dio.post<dynamic>(
        path,
        data: body,
        options: Options(
          extra: {'authenticated': authenticated},
          validateStatus: (status) =>
              status != null && successCodes.contains(status),
        ),
      );
      if (response.data == null || (response.data is String && (response.data as String).isEmpty)) {
        return <String, dynamic>{};
      }
      return response.data as Map<String, dynamic>;
    });
  }

  // PATCH 요청
  // Sends a PATCH request
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    List<int> successCodes = const [200, 204],
  }) {
    return _execute(() async {
      final response = await _dio.patch<dynamic>(
        path,
        data: body,
        options: Options(
          extra: {'authenticated': true},
          validateStatus: (status) =>
              status != null && successCodes.contains(status),
        ),
      );
      if (response.data == null || (response.data is String && (response.data as String).isEmpty)) {
        return <String, dynamic>{};
      }
      return response.data as Map<String, dynamic>;
    });
  }

  // DELETE 요청
  // Sends a DELETE request
  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    List<int> successCodes = const [200, 204],
  }) {
    return _execute(() async {
      final response = await _dio.delete<dynamic>(
        path,
        data: body,
        options: Options(
          extra: {'authenticated': true},
          validateStatus: (status) =>
              status != null && successCodes.contains(status),
        ),
      );
      if (response.data == null || (response.data is String && (response.data as String).isEmpty)) {
        return <String, dynamic>{};
      }
      return response.data as Map<String, dynamic>;
    });
  }

  // 공통 실행 래퍼: 에러를 ApiException으로 변환
  // Common executor: wraps errors into ApiException
  Future<T> _execute<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      // 인터셉터에서 발생한 ApiException은 그대로 전달
      // Re-throw ApiException raised inside interceptors
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      final statusCode = e.response?.statusCode ?? 0;
      final message =
          e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      throw ApiException(statusCode: statusCode, message: message);
    } catch (e, stack) {
      // 예상치 못한 에러는 Crashlytics에 기록
      // Log unexpected errors to Crashlytics
      await FirebaseCrashlytics.instance.recordError(e, stack);
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }
}

// 인증 요청에 Bearer 토큰을 자동 주입하는 인터셉터
// Interceptor that auto-injects Bearer token for authenticated requests
/// Automatically injects Bearer token for authenticated requests.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 요청의 authenticated 옵션 확인
    // Check if the request requires authentication
    final authenticated = options.extra['authenticated'] ?? true;
    if (authenticated == true) {
      final token = await _storage.read(key: _kServerTokenKey);
      // 토큰이 없으면 401 에러로 거부
      // Reject with 401 if no token is stored
      if (token == null) {
        return handler.reject(
          DioException(
            requestOptions: options,
            error: const ApiException(statusCode: 401, message: 'Not logged in'),
          ),
        );
      }
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

// 모든 HTTP 에러를 Firebase Crashlytics에 기록하는 인터셉터
// Interceptor that logs all HTTP errors to Firebase Crashlytics
/// Records all HTTP errors to Firebase Crashlytics.
class _CrashlyticsInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    FirebaseCrashlytics.instance.recordError(
      err,
      err.stackTrace,
      reason: '${err.requestOptions.method} ${err.requestOptions.path}',
    );
    handler.next(err);
  }
}
