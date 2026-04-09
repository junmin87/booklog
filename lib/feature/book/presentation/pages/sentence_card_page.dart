import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../domain/entity/book.dart';
import '../../domain/entity/sentence.dart';

class SentenceCardPage extends StatelessWidget {
  const SentenceCardPage({
    super.key,
    required this.sentence,
    required this.book,
  });

  final Sentence sentence;
  final Book book;

  @override
  Widget build(BuildContext context) {

    debugPrint('SentenceCardPage >>> ');
    debugPrint('SentenceCardPage >>> ');
    return Scaffold(
      appBar: AppBar(title: const Text('Sentence')),
      body: Center(
        child: RepaintBoundary(
          child: _SentenceCard(sentence: sentence, book: book),
        ),
      ),
    );
  }
}

class _SentenceCard extends StatelessWidget {
  const _SentenceCard({required this.sentence, required this.book});

  final Sentence sentence;
  final Book book;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.overlayBlack87,
          image: book.coverUrl != null
              ? DecorationImage(
                  image: NetworkImage(book.coverUrl!),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.black.withValues(alpha: 0.6),
                    BlendMode.darken,
                  ),
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sentence.content,
                style: AppTextStyles.sentenceCardContent,
              ),
              const SizedBox(height: 16),
              Text(
                '— ${book.title}',
                style: AppTextStyles.sentenceCardAttribution,
              ),
              if (sentence.pageNumber != null)
                Text(
                  'p. ${sentence.pageNumber}',
                  style: TextStyle(
                    color: AppColors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
