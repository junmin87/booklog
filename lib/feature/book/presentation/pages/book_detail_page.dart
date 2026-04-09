import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';
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
                child: _SectionHeader(
                  title: 'Saved Sentences',
                  subtitle: sentences.isEmpty
                      ? '이 책에서 기억하고 싶은 문장을 남겨보세요'
                      : hasRepresentative
                      ? '${sentences.length}개의 문장 중 하나가 대표문장으로 선택되어 있어요'
                      : '${sentences.length}개의 문장이 있어요 · 대표문장을 골라보세요',
                ),
              ),

              if (sentences.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptySentenceView(
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
                                // 나중에 수정 모드 지원 시 여기 확장
                                // sentence: sentence,
                                // isEditMode: true,
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: Text('대표문장으로 설정할까요?', style: AppTextStyles.notoDialogTitle),
          content: Text(
            '이 문장이 이 책을 대표하는 한 문장으로 표시돼요.',
            style: AppTextStyles.notoDialogBody,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text('취소', style: AppTextStyles.notoDialogCancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('설정', style: AppTextStyles.notoDialogConfirm),
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
            content: Text('대표문장으로 설정했어요', style: AppTextStyles.notoBase),
            backgroundColor: AppColors.successSnackBarBg,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('대표문장 설정에 실패했어요', style: AppTextStyles.notoBase),
            backgroundColor: AppColors.errorSnackBarBg,
          ),
        );
      }
    }
  }
}

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
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BookCover(coverUrl: book.coverUrl),
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
                          _MetaChip(
                            label: sentenceCount == 0
                                ? '기록된 문장 없음'
                                : '문장 $sentenceCount개',
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
                  'Representative Line',
                  style: AppTextStyles.playfairAccentSmall.copyWith(
                    letterSpacing: 0.4,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Text(
                    '\u201c${book.representativeSentence!.trim()}\u201d',
                    style: AppTextStyles.notoRepresentativeQuote,
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
                    '아직 대표문장이 없어요',
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
            border: Border.all(
              color: AppColors.accent.withValues(alpha: 0.18),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('최근 남긴 문장', style: AppTextStyles.playfairAccentLabel),
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
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.playfairSectionTitle),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTextStyles.notoCaption),
        ],
      ),
    );
  }
}

class _EmptySentenceView extends StatelessWidget {
  const _EmptySentenceView({required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  size: 44,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 16),
                Text(
                  '아직 남겨둔 문장이 없어요',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.notoEmptyTitle,
                ),
                const SizedBox(height: 10),
                Text(
                  '이 책에서 기억하고 싶은 문장을 남겨보세요.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.notoEmptySubtitle,
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: onAdd,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(
                      color: AppColors.accent.withValues(alpha: 0.35),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text('첫 문장 남기기', style: AppTextStyles.notoButtonLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
            border: Border.all(
              color: isRepresentative
                  ? AppColors.accent.withValues(alpha: 0.55)
                  : AppColors.white.withValues(alpha: 0.05),
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 14, 14),
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
                        child: Text('대표 문장', style: AppTextStyles.notoChipAccent),
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
                        isRepresentative ? '대표 문장' : '대표로 설정',
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
      ),
    );
  }
}

class _BookCover extends StatelessWidget {
  const _BookCover({required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 92,
        height: 132,
        child: coverUrl != null
            ? Image.network(
          coverUrl!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const _CoverFallback(),
        )
            : const _CoverFallback(),
      ),
    );
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: AppColors.muted,
          size: 34,
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.accent.withValues(alpha: 0.22),
        ),
      ),
      child: Text(label, style: AppTextStyles.notoChipMuted),
    );
  }
}
