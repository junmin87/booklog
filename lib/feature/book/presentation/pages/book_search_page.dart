import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../core/service/review_service.dart';
import '../../domain/entity/book_search_result.dart';
import '../provider/book_search_provider.dart';

class BookSearchPage extends ConsumerWidget {
  const BookSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncState = ref.watch(bookSearchNotifierProvider);
    final state = asyncState.valueOrNull ?? const BookSearchState();

    return Scaffold(
      appBar: AppBar(
        title: _SearchField(
          onSearch: (q) =>
              ref.read(bookSearchNotifierProvider.notifier).searchBooks(q),
        ),
      ),
      body: _buildBody(context, ref, asyncState.isLoading, state),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, bool isSearching,
      BookSearchState state) {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: AppColors.errorRed)),
      );
    }

    if (!state.hasSearched) {
      return _buildBestsellerSection(context, ref, state);
    }

    if (state.results.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.searchForBook));
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: state.results.length,
          itemBuilder: (context, i) => _BookTile(result: state.results[i]),
        ),
        if (state.isAdding)
          const Positioned.fill(
            child: ColoredBox(
              color: AppColors.overlayLoading,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }

  Widget _buildBestsellerSection(
      BuildContext context, WidgetRef ref, BookSearchState state) {
    if (state.isLoadingBestsellers || state.bestsellers.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: state.bestsellers.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const Divider(height: 1),
                  const SizedBox(height: 20),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      // '베스트셀러',
                      AppLocalizations.of(context)!.bestseller,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              );
            }
            return _BookTile(result: state.bestsellers[i - 1]);
          },
        ),
        if (state.isAdding)
          const Positioned.fill(
            child: ColoredBox(
              color: AppColors.overlayLoading,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

class _SearchField extends StatefulWidget {
  const _SearchField({required this.onSearch});
  final ValueChanged<String> onSearch;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: false,
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.searchFieldHint,
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSearch,
    );
  }
}

class _BookTile extends ConsumerWidget {
  const _BookTile({required this.result});
  final BookSearchResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: result.cover != null
          ? Image.network(
        result.cover!,
        width: 56,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.book),
      )
          : const Icon(Icons.book),
      title: Text(result.title),
      subtitle: Text(
        [result.author, result.publisher].whereType<String>().join(' · '),
      ),
      onTap: () => _add(context, ref),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final success =
    await ref.read(bookSearchNotifierProvider.notifier).addBook(result);
    if (!context.mounted) return;

    final l10n = AppLocalizations.of(context)!;
    if (success) {
      ReviewService().requestReview();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bookAdded(result.title))),
      );
      Navigator.of(context).pop();
    } else {
      final error = ref.read(bookSearchNotifierProvider).value?.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? l10n.failedToAddBook)),
      );
    }
  }
}