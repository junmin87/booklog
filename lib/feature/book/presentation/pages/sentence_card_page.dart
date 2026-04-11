import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';

import '../../../../app/app_colors.dart';
import '../../../../core/service/share_service.dart';
import '../../domain/entity/book.dart';
import '../../domain/entity/sentence.dart';
import '../widgets/sentence_card.dart';

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
      appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.sentenceAppBarTitle)),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: RepaintBoundary(
                key: _cardKey,
                child: SentenceCard(
                    sentence: widget.sentence, book: widget.book),
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

