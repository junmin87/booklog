import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entity/book.dart';
import '../provider/book_provider.dart';

class BooksPage extends StatefulWidget {
  const BooksPage({super.key, required this.onOpenAddBook});

  final VoidCallback onOpenAddBook;

  @override
  State<BooksPage> createState() => _BooksPageState();
}

class _BooksPageState extends State<BooksPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: Consumer<BookProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }
          if (provider.books.isEmpty) {
            return const Center(child: Text('No books yet.'));
          }
          return ListView.builder(
            itemCount: provider.books.length,
            itemBuilder: (context, index) {
              final book = provider.books[index];
              return _BookListItem(book: book);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onOpenAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _BookListItem extends StatelessWidget {
  const _BookListItem({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: book.coverUrl != null
          ? Image.network(
              book.coverUrl!,
              width: 40,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.book),
            )
          : const Icon(Icons.book),
      title: Text(book.title),
      subtitle: book.author != null ? Text(book.author!) : null,
      trailing: _StatusBadge(status: book.status),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final ReadingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      ReadingStatus.wantToRead => ('Want to read', Colors.grey),
      ReadingStatus.reading => ('Reading', Colors.blue),
      ReadingStatus.finished => ('Done', Colors.green),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}
