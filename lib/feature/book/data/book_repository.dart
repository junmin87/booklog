import '../domain/entity/book.dart';

class BookRepository {
  final List<Book> _books = [];

  Future<void> addBook(Book book) async {
    _books.add(book);
  }

  Future<List<Book>> getBooks() async {
    return List.unmodifiable(_books);
  }
}
