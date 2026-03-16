import 'package:flutter/material.dart';

import 'add_book_page.dart';

class BooksPage extends StatelessWidget {
  const BooksPage({super.key, required this.onOpenAddBook});

  final VoidCallback onOpenAddBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Books')),
      body: const Center(child: Text('No books yet.')),
      floatingActionButton: FloatingActionButton(
        onPressed: onOpenAddBook,
        child: const Icon(Icons.add),
      ),
    );
  }
}
