import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../domain/entity/book.dart';

const _kServerTokenKey = 'serverToken';

class BookSearchResult {
  final String title;
  final String? author;
  final String? publisher;
  final String? pubDate;
  final String? isbn13;
  final String? cover;
  final String? description;
  final String? categoryName;

  const BookSearchResult({
    required this.title,
    this.author,
    this.publisher,
    this.pubDate,
    this.isbn13,
    this.cover,
    this.description,
    this.categoryName,
  });

  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      title: json['title'] as String,
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      pubDate: json['pubDate'] as String?,
      isbn13: json['isbn13'] as String?,
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Book toBook({ReadingStatus status = ReadingStatus.reading}) => Book(
        title: title,
        author: author,
        publisher: publisher,
        pubDate: pubDate,
        isbn13: isbn13,
        coverUrl: cover,
        description: description,
        categoryName: categoryName,
        status: status,
        createdAt: DateTime.now(),
      );
}

class BookRepository {
  final _storage = const FlutterSecureStorage();

  String get _baseUrl => dotenv.env['BASE_URL']!;

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
