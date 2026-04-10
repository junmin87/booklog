import 'dart:convert';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../error/api_exception.dart';

const _kServerTokenKey = 'serverToken';

class ApiClient {
  ApiClient({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  String get _baseUrl => dotenv.env['BASE_URL']!;

  Future<Map<String, String>> _authHeaders() async {
    final token = await _storage.read(key: _kServerTokenKey);
    if (token == null) throw const ApiException(statusCode: 401, message: 'Not logged in');
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Map<String, String> _jsonHeaders() => {'Content-Type': 'application/json'};

  void _checkStatus(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(
        statusCode: response.statusCode,
        message: response.body.isNotEmpty ? response.body : 'HTTP ${response.statusCode}',
      );
    }
  }

  Future<T> _execute<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on ApiException {
      rethrow;
    } catch (e, stack) {
      await FirebaseCrashlytics.instance.recordError(e, stack);
      rethrow;
    }
  }

  /// GET without authentication.
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? queryParameters,
    bool authenticated = true,
  }) {
    return _execute(() async {
      final uri = Uri.parse('$_baseUrl$path').replace(queryParameters: queryParameters);
      final headers = authenticated ? await _authHeaders() : _jsonHeaders();
      final response = await http.get(uri, headers: headers);
      _checkStatus(response);
      return jsonDecode(response.body) as Map<String, dynamic>;
    });
  }

  /// POST with JSON body.
  Future<Map<String, dynamic>> post(
    String path,
    Map<String, dynamic> body, {
    bool authenticated = true,
    List<int> successCodes = const [200, 201],
  }) {
    return _execute(() async {
      final headers = authenticated ? await _authHeaders() : _jsonHeaders();
      final response = await http.post(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
        body: jsonEncode(body),
      );
      if (!successCodes.contains(response.statusCode)) {
        throw ApiException(
          statusCode: response.statusCode,
          message: response.body.isNotEmpty ? response.body : 'HTTP ${response.statusCode}',
        );
      }
      if (response.body.isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body) as Map<String, dynamic>;
    });
  }

  /// PATCH with optional JSON body.
  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    List<int> successCodes = const [200, 204],
  }) {
    return _execute(() async {
      final headers = await _authHeaders();
      final response = await http.patch(
        Uri.parse('$_baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      );
      if (!successCodes.contains(response.statusCode)) {
        throw ApiException(
          statusCode: response.statusCode,
          message: response.body.isNotEmpty ? response.body : 'HTTP ${response.statusCode}',
        );
      }
      if (response.body.isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body) as Map<String, dynamic>;
    });
  }
}
