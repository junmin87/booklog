import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/book_search_result.dart';
import 'book_provider.dart';

enum BookSearchError { searchFailed, addFailed }

class BookSearchState {
  final List<BookSearchResult> results;
  final List<BookSearchResult> bestsellers;
  final bool isAdding;
  final bool isLoadingBestsellers;
  final bool hasSearched;
  final BookSearchError? error;

  const BookSearchState({
    this.results = const [],
    this.bestsellers = const [],
    this.isAdding = false,
    this.isLoadingBestsellers = false,
    this.hasSearched = false,
    this.error,
  });

  BookSearchState copyWith({
    List<BookSearchResult>? results,
    List<BookSearchResult>? bestsellers,
    bool? isAdding,
    bool? isLoadingBestsellers,
    bool? hasSearched,
    BookSearchError? error,
  }) {
    return BookSearchState(
      results: results ?? this.results,
      bestsellers: bestsellers ?? this.bestsellers,
      isAdding: isAdding ?? this.isAdding,
      isLoadingBestsellers: isLoadingBestsellers ?? this.isLoadingBestsellers,
      hasSearched: hasSearched ?? this.hasSearched,
      error: error ?? this.error,
    );
  }
}

class BookSearchNotifier extends AutoDisposeAsyncNotifier<BookSearchState> {
  @override
  Future<BookSearchState> build() async {
    await loadBestsellers();
    return state.valueOrNull ?? const BookSearchState();
  }

  Future<void> loadBestsellers() async {
    final current = state.valueOrNull ?? const BookSearchState();
    state = AsyncValue.data(current.copyWith(isLoadingBestsellers: true));
    try {
      final bestsellers =
          await ref.read(bookRepositoryProvider).getBestsellers();
      final after = state.valueOrNull ?? const BookSearchState();
      state = AsyncValue.data(
        after.copyWith(bestsellers: bestsellers, isLoadingBestsellers: false),
      );
    } catch (_) {
      final after = state.valueOrNull ?? const BookSearchState();
      state = AsyncValue.data(after.copyWith(isLoadingBestsellers: false));
    }
  }

  Future<void> searchBooks(String query) async {
    final bestsellers = state.valueOrNull?.bestsellers ?? [];
    if (query.trim().isEmpty) {
      state = AsyncValue.data(BookSearchState(bestsellers: bestsellers));
      return;
    }

    // Clear any previous error before starting a new search.
    state = const AsyncValue.loading();
    try {
      final results =
          await ref.read(bookRepositoryProvider).searchBooks(query.trim());
      state = AsyncValue.data(BookSearchState(
        results: results,
        bestsellers: bestsellers,
        hasSearched: true,
      ));
    } catch (_) {
      state = AsyncValue.data(BookSearchState(
        bestsellers: bestsellers,
        hasSearched: true,
        error: BookSearchError.searchFailed,
      ));
    }
  }

  Future<bool> addBook(BookSearchResult result) async {
    final current = state.value ?? const BookSearchState();
    state = AsyncValue.data(current.copyWith(isAdding: true));
    try {
      await ref.read(addBookUseCaseProvider).execute(result);
      ref.invalidate(bookNotifierProvider);
      state = AsyncValue.data(current.copyWith(isAdding: false));
      return true;
    } catch (_) {
      // Do not pollute search screen state with this error; the caller
      // surfaces a user-friendly message via SnackBar.
      state = AsyncValue.data(current.copyWith(isAdding: false));
      return false;
    }
  }
}

final bookSearchNotifierProvider =
    AsyncNotifierProvider.autoDispose<BookSearchNotifier, BookSearchState>(
  BookSearchNotifier.new,
);
