import 'package:flutter/foundation.dart';

import '../../data/book_repository.dart';

class BookSearchProvider with ChangeNotifier {
  final BookRepository _repository;

  BookSearchProvider(this._repository);

  List<BookSearchResult> results = [];
  bool isSearching = false;
  bool isAdding = false;
  String? error;

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      results = [];
      error = null;
      notifyListeners();
      return;
    }

    isSearching = true;
    error = null;
    notifyListeners();

    try {
      results = await _repository.searchBooks(query.trim());
    } catch (e) {
      error = e.toString();
      results = [];
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  Future<bool> addBook(BookSearchResult result) async {
    isAdding = true;
    error = null;
    notifyListeners();

    try {
      await _repository.addBook(result.toBook());
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isAdding = false;
      notifyListeners();
    }
  }
}
