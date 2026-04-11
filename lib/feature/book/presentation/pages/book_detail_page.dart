import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';
import '../widgets/book_cover.dart';
import '../widgets/empty_sentence_view.dart';
import '../widgets/meta_chip.dart';
import '../widgets/section_header.dart';
import 'sentence_card_page.dart';
import 'sentence_input_page.dart';

class BookDetailPage extends ConsumerWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookId = book.id;
    final asyncSentences = ref.watch(sentenceNotifierProvider(bookId));

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        titleSpacing: 20,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          book.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: AppTextStyles.playfairAppBarTitle.copyWith(
            fontSize: 24,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: asyncSentences.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(
          child: Text(e.toString(), style: AppTextStyles.notoBodySecondary),
        ),
        data: (sentences) {
          final hasRepresentative = book.representativeSentence != null &&
              book.representativeSentence!.trim().isNotEmpty;
          final recentSentence = sentences.isNotEmpty ? sentences.first : null;
          final l10n = AppLocalizations.of(context)!;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _BookHeroSection(
                  book: book,
                  sentenceCount: sentences.length,
                ),
              ),

              if (recentSentence != null)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
                    child: _RecentSentenceCard(
                      sentence: recentSentence,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => SentenceCardPage(
                              sentence: recentSentence,
                              book: book,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

              SliverToBoxAdapter(
                child: SectionHeader(
                  title: l10n.savedSentences,
                  subtitle: sentences.isEmpty
                      ? l10n.noSentencesHint
                      : hasRepresentative
                      ? l10n.sentencesWithRepresentative(sentences.length)
                      : l10n.sentencesChooseRepresentative(sentences.length),
                ),
              ),

              if (sentences.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: EmptySentenceView(
                    onAdd: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => SentenceInputPage(book: book),
                        ),
                      );
                    },
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 120),
                  sliver: SliverList.separated(
                    itemCount: sentences.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, i) {
                      final sentence = sentences[i];
                      final isRepresentative =
                          (book.representativeSentence?.trim().isNotEmpty ?? false) &&
                              sentence.content.trim() ==
                                  book.representativeSentence!.trim();

                      return _SentenceListCard(
                        sentence: sentence,
                        isRepresentative: isRepresentative,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  SentenceCardPage(sentence: sentence, book: book),
                            ),
                          );
                        },
                        onEdit: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => SentenceInputPage(
                                book: book,
                              ),
                            ),
                          );
                        },
                        onSetRepresentative: () async {
                          await _confirmSetRepresentative(
                            context: context,
                            ref: ref,
                            bookId: bookId,
                            sentenceId: sentence.id,
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent,
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => SentenceInputPage(book: book),
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }

  Future<void> _confirmSetRepresentative({
    required BuildContext context,
    required WidgetRef ref,
    required String bookId,
    required String sentenceId,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: Text(l10n.setRepresentativeTitle, style: AppTextStyles.notoDialogTitle),
          content: Text(
            l10n.setRepresentativeContent,
            style: AppTextStyles.notoDialogBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel, style: AppTextStyles.notoDialogCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.setConfirm, style: AppTextStyles.notoDialogConfirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    try {
      await ref
          .read(sentenceNotifierProvider(bookId).notifier)
          .setRepresentative(bookId, sentenceId);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.representativeSetSuccess, style: AppTextStyles.notoBase),
            backgroundColor: AppColors.successSnackBarBg,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.representativeSetFailed, style: AppTextStyles.notoBase),
            backgroundColor: AppColors.errorSnackBarBg,
          ),
        );
      }
    }
  }
}

// ─── Hero Section (border removed, quote bar added) ─────────────────────────

class _BookHeroSection extends StatelessWidget {
  const _BookHeroSection({
    required this.book,
    required this.sentenceCount,
  });

  final Book book;
  final int sentenceCount;

  @override
  Widget build(BuildContext context) {
    final hasRepresentative =
        book.representativeSentence != null && book.representativeSentence!.trim().isNotEmpty;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BookCover(coverUrl: book.coverUrl),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(book.title, style: AppTextStyles.notoBookTitle),
                          if (book.author != null &&
                              book.author!.trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Text(book.author!, style: AppTextStyles.notoAuthor),
                          ],
                          const SizedBox(height: 12),
                          MetaChip(
                            label: sentenceCount == 0
                                ? AppLocalizations.of(context)!.noSentencesChip
                                : AppLocalizations.of(context)!.sentenceCountChip(sentenceCount),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              if (hasRepresentative) ...[
                Text(
                  AppLocalizations.of(context)!.representativeLine,
                  style: AppTextStyles.playfairAccentSmall.copyWith(
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 3,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '\u201c${book.representativeSentence!.trim()}\u201d',
                            style: AppTextStyles.notoRepresentativeQuote,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.noRepresentativeYet,
                    style: AppTextStyles.notoNoRepresentative,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Recent Sentence Card ───────────────────────────────────────────────────

class _RecentSentenceCard extends StatelessWidget {
  const _RecentSentenceCard({
    required this.sentence,
    required this.onTap,
  });

  final dynamic sentence;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.darkCardAlt,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 3,
                  margin: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.accent.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(13, 14, 16, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(AppLocalizations.of(context)!.recentSentenceTitle, style: AppTextStyles.playfairAccentLabel),
                        const SizedBox(height: 8),
                        Text(
                          sentence.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.notoBodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sentence List Card (border → accent bar) ───────────────────────────────

class _SentenceListCard extends StatelessWidget {
  const _SentenceListCard({
    required this.sentence,
    required this.onTap,
    required this.onEdit,
    required this.onSetRepresentative,
    required this.isRepresentative,
  });

  final dynamic sentence;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onSetRepresentative;
  final bool isRepresentative;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: isRepresentative
                ? AppColors.darkCardRepresentative
                : AppColors.darkCard,
            borderRadius: BorderRadius.circular(20),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isRepresentative)
                  Container(
                    width: 3,
                    margin: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(
                      isRepresentative ? 13 : 16,
                      16,
                      14,
                      14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isRepresentative) ...[
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  AppLocalizations.of(context)!.representativeChip,
                                  style: AppTextStyles.notoChipAccent,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                        Text(
                          '\u201c${sentence.content}\u201d',
                          style: AppTextStyles.notoBodyContent,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            if (sentence.pageNumber != null)
                              Text(
                                'p. ${sentence.pageNumber}',
                                style: AppTextStyles.playfairAccentSmall,
                              ),
                            const Spacer(),
                            TextButton(
                              onPressed: isRepresentative ? null : onSetRepresentative,
                              style: TextButton.styleFrom(
                                foregroundColor: isRepresentative
                                    ? AppColors.onDarkDisabled
                                    : AppColors.accent,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              child: Text(
                                isRepresentative
                                    ? AppLocalizations.of(context)!.representativeChip
                                    : AppLocalizations.of(context)!.setAsRepresentative,
                                style: AppTextStyles.notoButtonSmall,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 20,
                              onPressed: onEdit,
                              icon: const Icon(
                                Icons.edit_outlined,
                                size: 20,
                                color: AppColors.onDarkSecondary,
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              splashRadius: 20,
                              onPressed: onTap,
                              icon: const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 18,
                                color: AppColors.onDarkMuted,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

