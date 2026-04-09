import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
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
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        centerTitle: false,
        title: Text('My Books', style: AppTextStyles.playfairPageTitle),
      ),
      body: asyncBooks.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 56,
                    color: AppColors.muted,
                  ),
                  const SizedBox(height: 16),
                  Text('아직 등록된 책이 없어요', style: AppTextStyles.notoMuted),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 100),
            itemCount: books.length,
            itemBuilder: (context, index) => _BookCard(book: books[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const BookSearchPage()),
        ),
        backgroundColor: AppColors.accent,
        child: const Icon(Icons.add, color: AppColors.white),
      ),
    );
  }
}

class _BookCard extends StatelessWidget {
  const _BookCard({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    final hasSentence = book.representativeSentence != null &&
        book.representativeSentence!.trim().isNotEmpty;

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => BookDetailPage(book: book)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              fit: StackFit.expand,
              children: [
                _CoverLayer(coverUrl: book.coverUrl),

                // 기존 전체 오버레이보다 조금 더 진하게 조정해서 전체적인 가독성 강화
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.overlayMid,
                        AppColors.overlayFaint,
                        AppColors.overlayStrong,
                      ],
                      stops: [0.0, 0.42, 1.0],
                    ),
                  ),
                ),

                // 하단 딤도 조금 강화
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.22, 1.0],
                        colors: [
                          Colors.transparent,
                          AppColors.overlayHeavy,
                        ],
                      ),
                    ),
                  ),
                ),

                // 중앙 문장 / 문장 없음 UI
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasSentence) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.black.withValues(alpha: 0.34),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 3,
                                  height: 92,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      RichText(
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: '\u201c',
                                              style: AppTextStyles.notoCardQuoteMark,
                                            ),
                                            TextSpan(
                                              text: book.representativeSentence!.trim(),
                                              style: AppTextStyles.notoCardQuoteText,
                                            ),
                                            TextSpan(
                                              text: '\u201d',
                                              style: AppTextStyles.notoCardQuoteMark,
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 12),

                                      Text(
                                        '— ${book.title}',
                                        style: AppTextStyles.notoAttributionSubtle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ] else ...[
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 18,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkOverlayCard,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.accent,
                                width: 1.1,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: 4,
                                  height: 52,
                                  decoration: BoxDecoration(
                                    color: AppColors.accent,
                                    borderRadius: BorderRadius.circular(99),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Text(
                                    '첫 문장을 기록해보세요',
                                    style: AppTextStyles.notoCardCta,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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

class _CoverLayer extends StatelessWidget {
  const _CoverLayer({required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    if (coverUrl != null) {
      return Image.network(
        coverUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _CoverFallback(),
      );
    }
    return const _CoverFallback();
  }
}

class _CoverFallback extends StatelessWidget {
  const _CoverFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book_rounded,
              size: 48,
              color: AppColors.muted,
            ),
            const SizedBox(height: 8),
            Text('No Cover', style: AppTextStyles.playfairFallback),
          ],
        ),
      ),
    );
  }
}
