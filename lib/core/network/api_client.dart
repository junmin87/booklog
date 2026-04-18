import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../error/api_exception.dart';

const _kServerTokenKey = 'serverToken';

class ApiClient {
  ApiClient({FlutterSecureStorage? storage, @visibleForTesting Dio? dio})
      : _storage = storage ?? const FlutterSecureStorage() {
    _dio = dio ??
        Dio(BaseOptions(
          baseUrl: dotenv.env['BASE_URL']!,
          contentType: 'application/json',
        ));

    _dio.interceptors.add(_AuthInterceptor(_storage));
    if (dio == null) {
      _dio.interceptors.add(_CrashlyticsInterceptor());
    }
  }

  final FlutterSecureStorage _storage;
  late final Dio _dio;

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

  Future<T> _execute<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ApiException {
      rethrow;
    } on DioException catch (e) {
      if (e.error is ApiException) {
        throw e.error as ApiException;
      }
      final statusCode = e.response?.statusCode ?? 0;
      final message =
          e.response?.data?.toString() ?? e.message ?? 'Unknown error';
      throw ApiException(statusCode: statusCode, message: message);
    } catch (e, stack) {
      await FirebaseCrashlytics.instance.recordError(e, stack);
      throw ApiException(statusCode: 0, message: e.toString());
    }
  }
}

/// Automatically injects Bearer token for authenticated requests.
class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);
  final FlutterSecureStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authenticated = options.extra['authenticated'] ?? true;
    if (authenticated == true) {
      final token = await _storage.read(key: _kServerTokenKey);
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
