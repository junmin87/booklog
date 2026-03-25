import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/book_repository.dart';
import '../provider/book_search_provider.dart';

class BookSearchPage extends StatelessWidget {
  const BookSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookSearchProvider(BookRepository()),
      child: const _BookSearchView(),
    );
  }
}

class _BookSearchView extends StatelessWidget {
  const _BookSearchView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookSearchProvider>();

    return Scaffold(
      appBar: AppBar(
        title: _SearchField(
          onSearch: (q) => context.read<BookSearchProvider>().searchBooks(q),
        ),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, BookSearchProvider provider) {
    if (provider.isSearching) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error != null) {
      return Center(
        child: Text(provider.error!, style: const TextStyle(color: Colors.red)),
      );
    }

    if (provider.results.isEmpty) {
      return const Center(child: Text('Search for a book by title or author'));
    }

    return Stack(
      children: [
        ListView.builder(
          itemCount: provider.results.length,
          itemBuilder: (context, i) =>
              _BookTile(result: provider.results[i]),
        ),
        if (provider.isAdding)
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

class _BookTile extends StatelessWidget {
  const _BookTile({required this.result});
  final BookSearchResult result;

  @override
  Widget build(BuildContext context) {
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
      onTap: () => _add(context),
    );
  }

  Future<void> _add(BuildContext context) async {
    final provider = context.read<BookSearchProvider>();
    final success = await provider.addBook(result);
    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('"${result.title}" added')),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.error ?? 'Failed to add book')),
      );
    }
  }
}
