import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';

class SentenceInputPage extends ConsumerStatefulWidget {
  const SentenceInputPage({super.key, required this.book});

  final Book book;

  @override
  ConsumerState<SentenceInputPage> createState() => _SentenceInputPageState();
}

class _SentenceInputPageState extends ConsumerState<SentenceInputPage> {
  final _contentController = TextEditingController();
  final _pageController = TextEditingController();
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      setState(() => _error = 'Please enter sentence content');
      return;
    }

    final pageText = _pageController.text.trim();
    final pageNumber = pageText.isNotEmpty ? int.tryParse(pageText) : null;
    final bookId = widget.book.id?.toString() ?? '';

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await ref
          .read(sentenceNotifierProvider(bookId).notifier)
          .addSentence(bookId, content, pageNumber: pageNumber);
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Sentence')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Sentence',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Page number (optional)',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
