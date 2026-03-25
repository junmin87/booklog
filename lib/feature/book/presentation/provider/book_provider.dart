import 'package:flutter/foundation.dart';

import '../../data/book_repository.dart';
import '../../domain/entity/book.dart';

class BookProvider with ChangeNotifier {
  final BookRepository _repository;

  BookProvider(this._repository);

  List<Book> books = [];
  bool isLoading = false;
  String? error;

  Future<void> fetchBooks() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      books = await _repository.getBooks();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addBook(Book book) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await _repository.addBook(book);
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
