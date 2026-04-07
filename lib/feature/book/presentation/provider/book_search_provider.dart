import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/book_search_result.dart';
import 'book_provider.dart';

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

class BookSearchNotifier extends AutoDisposeAsyncNotifier<BookSearchState> {
  @override
  Future<BookSearchState> build() async => const BookSearchState();

  Future<void> searchBooks(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data(BookSearchState());
      return;
    }

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
      await ref.read(addBookUseCaseProvider).execute(result);
      ref.invalidate(bookNotifierProvider);
      state = AsyncValue.data(BookSearchState(results: current.results));
      return true;
    } catch (e) {
      state = AsyncValue.data(
          BookSearchState(results: current.results, error: e.toString()));
      return false;
    }
  }
}

final bookSearchNotifierProvider =
    AsyncNotifierProvider.autoDispose<BookSearchNotifier, BookSearchState>(
  BookSearchNotifier.new,
);
