import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../domain/entity/book.dart';
import '../../domain/entity/sentence.dart';

class SentenceCard extends StatelessWidget {
  const SentenceCard({super.key, required this.sentence, required this.book});

  final Sentence sentence;
  final Book book;

  double _adaptiveFontSize(String text) {
    final len = text.length;
    if (len <= 10) return 28;
    if (len <= 30) return 22;
    if (len <= 80) return 18;
    if (len <= 150) return 16;
    return 14;
  }

  double _adaptiveLineHeight(String text) {
    final len = text.length;
    if (len <= 30) return 1.4;
    if (len <= 80) return 1.55;
    return 1.65;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        margin: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1) Cover image or fallback
              if (book.coverUrl != null)
                Image.network(
                  book.coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const CardFallbackBg(),
                )
              else
                const CardFallbackBg(),

              // 2) Top: subtle dim to keep cover visible
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.35, 0.65, 1.0],
                    colors: [
                      AppColors.black.withValues(alpha: 0.15),
                      AppColors.black.withValues(alpha: 0.25),
                      AppColors.black.withValues(alpha: 0.55),
                      AppColors.black.withValues(alpha: 0.82),
                    ],
                  ),
                ),
              ),

              // 3) Content pinned to bottom
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Quote bar + sentence
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Sentence text
                                Text(
                                  sentence.content,
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: _adaptiveFontSize(sentence.content),
                                    fontWeight: FontWeight.w600,
                                    height: _adaptiveLineHeight(sentence.content),
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 14),
                                // Book title
                                Text(
                                  '— ${book.title}',
                                  style: TextStyle(
                                    color: AppColors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Author (if exists)
                                if (book.author != null &&
                                    book.author!.trim().isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3),
                                    child: Text(
                                      book.author!,
                                      style: TextStyle(
                                        color: AppColors.white
                                            .withValues(alpha: 0.38),
                                        fontSize: 11,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                // Page number (if exists)
                                if (sentence.pageNumber != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 2),
                                    child: Text(
                                      'p. ${sentence.pageNumber}',
                                      style: TextStyle(
                                        color: AppColors.white
                                            .withValues(alpha: 0.3),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Watermark
                    Align(
                      alignment: Alignment.centerRight,
                      child: Opacity(
                        opacity: 0.28,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 13,
                              color: AppColors.white,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'BOOK LOG',
                              style: TextStyle(
                                color: AppColors.white,
                                fontSize: 10,
                                letterSpacing: 1.8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fallback background when no cover image is available
class CardFallbackBg extends StatelessWidget {
  const CardFallbackBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF2C2520),
            Color(0xFF1A1614),
          ],
        ),
      ),
    );
  }
}
