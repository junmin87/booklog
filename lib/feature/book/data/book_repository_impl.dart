import '../../../core/network/api_client.dart';
import '../domain/entity/book.dart';
import '../domain/entity/book_search_result.dart';
import '../domain/repository/book_repository.dart';

class BookRepositoryImpl implements BookRepository {
  BookRepositoryImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<List<BookSearchResult>> searchBooks(String query) async {
    final data = await _api.get(
      '/book/search',
      queryParameters: {'query': query},
      authenticated: false,
    );
    final books = data['books'] as List<dynamic>;
    return books
        .map((b) => BookSearchResult.fromJson(b as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addBook(Book book) async {
    await _api.post('/book/add', {
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
    });
  }

  @override
  Future<List<Book>> getBooks() async {
    final data = await _api.get('/book/list');
    final books = data['books'] as List<dynamic>;
    return books
        .map((b) => Book.fromJson(b as Map<String, dynamic>))
        .toList();
  }
}
