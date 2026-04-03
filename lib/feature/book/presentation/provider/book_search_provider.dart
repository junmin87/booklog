import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../data/book_repository.dart';

// Migration: Immutable state class replaces public mutable fields on ChangeNotifier
class BookSearchState {
  final List<BookSearchResult> results;
  final bool isAdding;
  final String? error;

  const BookSearchState({
    this.results = const [],
    this.isAdding = false,
    this.error,
  });
}

// Migration: AutoDisposeAsyncNotifier disposes when BookSearchPage is popped; replaces scoped ChangeNotifierProvider
class BookSearchNotifier extends AutoDisposeAsyncNotifier<BookSearchState> {
  @override
  Future<BookSearchState> build() async => const BookSearchState();

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data(BookSearchState());
      return;
    }

    // Migration: state = AsyncValue.loading() replaces isSearching flag + notifyListeners()
    state = const AsyncValue.loading();
    try {
      final results =
          await ref.read(bookRepositoryProvider).searchBooks(query.trim());
      state = AsyncValue.data(BookSearchState(results: results));
    } catch (e) {
      state = AsyncValue.data(BookSearchState(error: e.toString()));
    }
  }

  Future<bool> addBook(BookSearchResult result) async {
    final current = state.value ?? const BookSearchState();
    state = AsyncValue.data(
        BookSearchState(results: current.results, isAdding: true));
    try {
      await ref.read(bookRepositoryProvider).addBook(result.toBook());
      state = AsyncValue.data(BookSearchState(results: current.results));
      return true;
    } catch (e) {
      state = AsyncValue.data(
          BookSearchState(results: current.results, error: e.toString()));
      return false;
    }
  }
}

// Migration: autoDispose cleans up provider automatically when BookSearchPage is popped
final bookSearchNotifierProvider =
    AsyncNotifierProvider.autoDispose<BookSearchNotifier, BookSearchState>(
  BookSearchNotifier.new,
);
