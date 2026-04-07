import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';
import 'sentence_card_page.dart';
import 'sentence_input_page.dart';

class BookDetailPage extends ConsumerWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = book.id?.toString() ?? '';
    final asyncSentences = ref.watch(sentenceNotifierProvider(bookId));

    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: asyncSentences.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (sentences) {
          if (sentences.isEmpty) {
            return const Center(child: Text('No sentences yet.'));
          }
          return ListView.builder(
            itemCount: sentences.length,
            itemBuilder: (context, i) {
              final sentence = sentences[i];
              return ListTile(
                title: Text(
                  sentence.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: sentence.pageNumber != null
                    ? Text('p. ${sentence.pageNumber}')
                    : null,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        SentenceCardPage(sentence: sentence, book: book),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SentenceInputPage(book: book),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
