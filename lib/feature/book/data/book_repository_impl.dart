import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../domain/entity/book.dart';
import '../domain/entity/book_search_result.dart';
import '../domain/repository/book_repository.dart';

const _kServerTokenKey = 'serverToken';

class BookRepositoryImpl implements BookRepository {
  final _storage = const FlutterSecureStorage();

  String get _baseUrl => dotenv.env['BASE_URL']!;

  @override
  Future<List<BookSearchResult>> searchBooks(String query) async {
    final uri = Uri.parse('$_baseUrl/book/search').replace(
      queryParameters: {'query': query},
    );
    final response = await http.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Search failed: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final books = data['books'] as List<dynamic>;
    return books
        .map((b) => BookSearchResult.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addBook(Book book) async {
    final token = await _storage.read(key: _kServerTokenKey);
    if (token == null) throw Exception('Not logged in');

    final response = await http.post(
      Uri.parse('$_baseUrl/book/add'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'title': book.title,
        'author': book.author,
        'publisher': book.publisher,
        'pub_date': book.pubDate,
        'isbn13': book.isbn13,
        'cover_url': book.coverUrl,
        'description': book.description,
        'category_name': book.categoryName,
        'status': book.status.apiValue,
        'current_page': 0,
        'total_page': null,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Add book failed: ${response.statusCode}');
    }
  }

  @override
  Future<List<Book>> getBooks() async {
    final token = await _storage.read(key: _kServerTokenKey);
    if (token == null) throw Exception('Not logged in');

    final response = await http.get(
      Uri.parse('$_baseUrl/book/list'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load books: ${response.statusCode}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final books = data['books'] as List<dynamic>;
    return books
        .map((b) => Book.fromJson(b as Map<String, dynamic>))
        .toList();
  }
}
