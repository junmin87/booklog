import 'package:flutter/foundation.dart';

import '../../data/book_repository.dart';
import '../../domain/entity/book.dart';

class BookProvider with ChangeNotifier {
  final BookRepository _repository;

  BookProvider(this._repository);

  bool isLoading = false;
  String? error;

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
