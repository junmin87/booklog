import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: const Color(0xFF0F0E0C),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F0E0C),
        elevation: 0,
        centerTitle: false,
        title: Text(
          'My Books',
          style: GoogleFonts.playfairDisplay(
            color: const Color(0xFFF7F3EE),
            fontSize: 28,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.5,
          ),
        ),
      ),
      body: asyncBooks.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFC2773A)),
        ),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (books) {
          if (books.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_rounded,
                      size: 56, color: const Color(0xFF78716C)),
                  const SizedBox(height: 16),
                  Text(
                    '아직 등록된 책이 없어요',
                    style: GoogleFonts.notoSerifKr(
                      color: const Color(0xFF78716C),
                      fontSize: 15,
                    ),
                  ),
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
        backgroundColor: const Color(0xFFC2773A),
        child: const Icon(Icons.add, color: Colors.white),
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
        book.representativeSentence!.isNotEmpty;

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
                // 책 표지
                _CoverLayer(coverUrl: book.coverUrl),

                // 전체 오버레이 — 진하게
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x55000000),
                        Color(0x22000000),
                        Color(0xCC000000),
                      ],
                      stops: [0.0, 0.4, 1.0],
                    ),
                  ),
                ),

                // 하단 강한 딤
                const Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.3, 1.0],
                        colors: [
                          Colors.transparent,
                          Color(0xF0000000),
                        ],
                      ),
                    ),
                  ),
                ),

                // 좌상단 — 얇은 액센트 라인
                Positioned(
                  top: 24,
                  left: 24,
                  child: Container(
                    width: 32,
                    height: 2,
                    color: const Color(0xFFC2773A),
                  ),
                ),

                // 중앙 문장
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasSentence) ...[
                          Text(
                            '\u201c',
                            style: GoogleFonts.playfairDisplay(
                              color: const Color(0xFFC2773A),
                              fontSize: 64,
                              height: 0.8,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            book.representativeSentence!,
                            style: GoogleFonts.notoSerifKr(
                              color: const Color(0xFFF7F3EE),
                              fontSize: 18,
                              height: 1.85,
                              fontWeight: FontWeight.w300,
                              letterSpacing: 0.2,
                            ),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ] else ...[
                          // 문장 없을 때 — 배경 박스로 강조
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC2773A).withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: const Color(0xFFC2773A).withValues(alpha: 0.4),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              '첫 문장을 기록해보세요',
                              style: GoogleFonts.notoSerifKr(
                                color: const Color(0xFFC2773A),
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // 하단 책 정보
                Positioned(
                  left: 28,
                  right: 28,
                  bottom: 28,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24,
                        height: 0.5,
                        color: const Color(0x80FFFFFF),
                        margin: const EdgeInsets.only(bottom: 12),
                      ),
                      Text(
                        book.title,
                        style: GoogleFonts.playfairDisplay(
                          color: const Color(0xCCFFFFFF),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (book.author != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          book.author!,
                          style: GoogleFonts.notoSerifKr(
                            color: const Color(0x80FFFFFF),
                            fontSize: 11,
                            letterSpacing: 0.3,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
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
      color: const Color(0xFF1C1917),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_rounded,
                size: 48, color: const Color(0xFF78716C)),
            const SizedBox(height: 8),
            Text(
              'No Cover',
              style: GoogleFonts.playfairDisplay(
                color: const Color(0xFF78716C),
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}