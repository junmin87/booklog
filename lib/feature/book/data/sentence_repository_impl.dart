import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../domain/entity/sentence.dart';
import '../domain/repository/sentence_repository.dart';

const _kServerTokenKey = 'serverToken';

class SentenceRepositoryImpl implements SentenceRepository {
  final _storage = const FlutterSecureStorage();

  String get _baseUrl => dotenv.env['BASE_URL']!;

  @override
  Future<void> addSentence(String bookId, String content,
      {int? pageNumber}) async {
    final token = await _storage.read(key: _kServerTokenKey);
    if (token == null) throw Exception('Not logged in');

    final response = await http.post(
      Uri.parse('$_baseUrl/books/$bookId/sentences'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'content': content,
        if (pageNumber != null) 'pageNumber': pageNumber,
      }),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Add sentence failed: ${response.statusCode}');
    }
  }

  @override
  Future<List<Sentence>> getSentences(String bookId) async {
    debugPrint('getSentences >>  ${bookId} ');
    debugPrint('getSentences >>  ${bookId} ');

    final token = await _storage.read(key: _kServerTokenKey);
    if (token == null) throw Exception('Not logged in');

    final response = await http.get(
      Uri.parse('$_baseUrl/books/$bookId/sentences'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load sentences: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final sentences = data['sentences'] as List<dynamic>;
    return sentences
        .map((s) => Sentence.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
