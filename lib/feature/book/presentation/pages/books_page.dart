import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/book.dart';
import '../provider/book_provider.dart';
import 'book_detail_page.dart';
import 'book_search_page.dart';

class BooksPage extends ConsumerWidget {
  const BooksPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncBooks = ref.watch(bookNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: asyncBooks.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (books) {
          if (books.isEmpty) return const Center(child: Text('No books yet.'));
          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) => _BookListItem(book: books[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BookSearchPage()),
        ),
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
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => BookDetailPage(book: book),
        ),
      ),
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
