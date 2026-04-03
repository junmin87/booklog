import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/book_repository.dart';
import '../provider/book_search_provider.dart';

// Migration: ConsumerWidget replaces the StatelessWidget that wrapped a scoped ChangeNotifierProvider
class BookSearchPage extends ConsumerWidget {
  const BookSearchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Migration: ref.watch replaces context.watch; autoDispose provider cleans up when page is popped
    final asyncState = ref.watch(bookSearchNotifierProvider);
    final state = asyncState.valueOrNull ?? const BookSearchState();

    return Scaffold(
      appBar: AppBar(
        title: _SearchField(
          // Migration: ref.read(provider.notifier) replaces context.read<T>() for triggering actions
          onSearch: (q) =>
              ref.read(bookSearchNotifierProvider.notifier).searchBooks(q),
        ),
      ),
      body: _buildBody(context, ref, asyncState.isLoading, state),
    );
  }

  Widget _buildBody(
      BuildContext context, WidgetRef ref, bool isSearching, BookSearchState state) {
    if (isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Text(state.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (state.results.isEmpty) {
      return const Center(child: Text('Search for a book by title or author'));
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
              color: Colors.black26,
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
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Title or author...',
        border: InputBorder.none,
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: widget.onSearch,
    );
  }
}

// Migration: ConsumerWidget replaces StatelessWidget to access ref for provider read/write
class _BookTile extends ConsumerWidget {
  const _BookTile({required this.result});
  final BookSearchResult result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: result.cover != null
          ? Image.network(
              result.cover!,
              width: 40,
              height: 60,
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

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${result.title}" added')),
      );
      Navigator.of(context).pop(true);
    } else {
      final error = ref.read(bookSearchNotifierProvider).value?.error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'Failed to add book')),
      );
    }
  }
}
