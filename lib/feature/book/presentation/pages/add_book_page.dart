import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/book.dart';
import '../provider/book_provider.dart';
import 'book_search_page.dart';

// Migration: ConsumerStatefulWidget replaces StatefulWidget to access ref alongside local form state
class AddBookPage extends ConsumerStatefulWidget {
  const AddBookPage({super.key});

  @override
  ConsumerState<AddBookPage> createState() => _AddBookPageState();
}

class _AddBookPageState extends ConsumerState<AddBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _notesController = TextEditingController();

  ReadingStatus _status = ReadingStatus.wantToRead;
  int? _rating;
  // Migration: local state tracks submit loading/error; provider.isLoading/error are no longer shared here
  bool _isSubmitting = false;
  String? _submitError;

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final book = Book(
      title: _titleController.text.trim(),
      author: _authorController.text.trim().isEmpty
          ? null
          : _authorController.text.trim(),
      status: _status,
      rating: _rating,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      createdAt: DateTime.now(),
    );

    setState(() {
      _isSubmitting = true;
      _submitError = null;
    });

    // Migration: ref.read(provider.notifier).method() replaces context.read<T>().method()
    final success = await ref.read(bookNotifierProvider.notifier).addBook(book);
    if (!mounted) return;

    if (success) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _isSubmitting = false;
        _submitError = 'Failed to add book';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Book'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search books',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BookSearchPage()),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title *'),
              textCapitalization: TextCapitalization.sentences,
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Title is required' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(labelText: 'Author'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<ReadingStatus>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: const [
                DropdownMenuItem(
                    value: ReadingStatus.wantToRead, child: Text('Want to Read')),
                DropdownMenuItem(
                    value: ReadingStatus.reading, child: Text('Reading')),
                DropdownMenuItem(
                    value: ReadingStatus.finished, child: Text('Finished')),
              ],
              onChanged: (v) => setState(() => _status = v!),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int?>(
              value: _rating,
              decoration: const InputDecoration(labelText: 'Rating'),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                ...List.generate(5, (i) => i + 1).map(
                  (n) => DropdownMenuItem(value: n, child: Text('$n / 5')),
                ),
              ],
              onChanged: (v) => setState(() => _rating = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            if (_submitError != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(_submitError!,
                    style: const TextStyle(color: Colors.red)),
              ),
            FilledButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
