import '../entity/book.dart';
import '../entity/book_search_result.dart';

abstract class BookRepository {
  Future<List<BookSearchResult>> searchBooks(String query);
  Future<List<BookSearchResult>> getBestsellers();
  Future<void> addBook(Book book);
  Future<List<Book>> getBooks();
}
