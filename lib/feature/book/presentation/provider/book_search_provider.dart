import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/book_search_result.dart';
import 'book_provider.dart';

class BookSearchState {
  final List<BookSearchResult> results;
  final List<BookSearchResult> bestsellers;
  final bool isAdding;
  final bool isLoadingBestsellers;
  final bool hasSearched;
  final String? error;

  const BookSearchState({
    this.results = const [],
    this.bestsellers = const [],
    this.isAdding = false,
    this.isLoadingBestsellers = false,
    this.hasSearched = false,
    this.error,
  });
}

class BookSearchNotifier extends AutoDisposeAsyncNotifier<BookSearchState> {
  @override
  Future<BookSearchState> build() async {
    await loadBestsellers();
    return state.valueOrNull ?? const BookSearchState();
  }

  Future<void> loadBestsellers() async {
    final current = state.valueOrNull ?? const BookSearchState();
    state = AsyncValue.data(BookSearchState(
      results: current.results,
      bestsellers: current.bestsellers,
      isAdding: current.isAdding,
      hasSearched: current.hasSearched,
      isLoadingBestsellers: true,
    ));
    try {
      final bestsellers =
          await ref.read(bookRepositoryProvider).getBestsellers();
      final after = state.valueOrNull ?? const BookSearchState();
      state = AsyncValue.data(BookSearchState(
        results: after.results,
        bestsellers: bestsellers,
        isAdding: after.isAdding,
        hasSearched: after.hasSearched,
        isLoadingBestsellers: false,
      ));
    } catch (_) {
      final after = state.valueOrNull ?? const BookSearchState();
      state = AsyncValue.data(BookSearchState(
        results: after.results,
        bestsellers: after.bestsellers,
        isAdding: after.isAdding,
        hasSearched: after.hasSearched,
        isLoadingBestsellers: false,
      ));
    }
  }

  Future<void> searchBooks(String query) async {
    final bestsellers = state.valueOrNull?.bestsellers ?? [];
    if (query.trim().isEmpty) {
      state = AsyncValue.data(BookSearchState(bestsellers: bestsellers));
      return;
    }

    state = const AsyncValue.loading();
    try {
      final results =
          await ref.read(bookRepositoryProvider).searchBooks(query.trim());
      state = AsyncValue.data(BookSearchState(
        results: results,
        bestsellers: bestsellers,
        hasSearched: true,
      ));
    } catch (e) {
      state = AsyncValue.data(BookSearchState(
        bestsellers: bestsellers,
        hasSearched: true,
        error: e.toString(),
      ));
    }
  }

  Future<bool> addBook(BookSearchResult result) async {
    final current = state.value ?? const BookSearchState();
    state = AsyncValue.data(BookSearchState(
      results: current.results,
      bestsellers: current.bestsellers,
      hasSearched: current.hasSearched,
      isAdding: true,
    ));
    try {
      await ref.read(addBookUseCaseProvider).execute(result);
      ref.invalidate(bookNotifierProvider);
      state = AsyncValue.data(BookSearchState(
        results: current.results,
        bestsellers: current.bestsellers,
        hasSearched: current.hasSearched,
      ));
      return true;
    } catch (e) {
      state = AsyncValue.data(BookSearchState(
        results: current.results,
        bestsellers: current.bestsellers,
        hasSearched: current.hasSearched,
        error: e.toString(),
      ));
      return false;
    }
  }
}

final bookSearchNotifierProvider =
    AsyncNotifierProvider.autoDispose<BookSearchNotifier, BookSearchState>(
  BookSearchNotifier.new,
);
