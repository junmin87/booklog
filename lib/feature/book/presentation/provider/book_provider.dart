import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/book.dart';

// Migration: AsyncNotifier replaces ChangeNotifier; build() fetches books on first ref access
class BookNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    // Migration: build() replaces fetchBooks() called in BooksPage.initState
    return ref.read(bookRepositoryProvider).getBooks();
  }

  // Future<bool> addBook(Book book) async {
  //   try {
  //     await ref.read(bookRepositoryProvider).addBook(book);
  //     // Migration: ref.invalidateSelf() re-runs build() to refresh the list; replaces manual notifyListeners()
  //     ref.invalidateSelf();
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> addBook(Book book) async {
    try {
      debugPrint('▶ addBook: calling repository...');
      await ref.read(bookRepositoryProvider).addBook(book);
      debugPrint('▶ addBook: repository success');
      ref.invalidateSelf();
      debugPrint('▶ addBook: after invalidateSelf, returning true');
      return true;
    } catch (e) {
      debugPrint('▶ addBook: caught error: $e');
      return false;
    }
  }
}

// Migration: AsyncNotifierProvider declared globally; replaces ChangeNotifierProvider in main.dart MultiProvider
final bookNotifierProvider =
    AsyncNotifierProvider<BookNotifier, List<Book>>(BookNotifier.new);
