import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../../../core/service/share_service.dart';
import '../../domain/entity/book.dart';
import '../../domain/entity/sentence.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entity/book.dart';
import '../../domain/entity/sentence.dart';

class SentenceCardPage extends StatefulWidget {
  const SentenceCardPage({
    super.key,
    required this.sentence,
    required this.book,
  });

  final Sentence sentence;
  final Book book;

  @override
  State<SentenceCardPage> createState() => _SentenceCardPageState();
}

class _SentenceCardPageState extends State<SentenceCardPage> {
  final GlobalKey _cardKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.sentenceAppBarTitle)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _cardKey,
                child: _SentenceCard(sentence: widget.sentence, book: widget.book),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _share(context),
                icon: const Icon(Icons.share_outlined),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: AppColors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _share(BuildContext context) async {
    try {
      await ShareService().shareCard(_cardKey);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.errorSnackBarBg,
        ),
      );
    }
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
