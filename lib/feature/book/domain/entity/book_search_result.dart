import 'package:freezed_annotation/freezed_annotation.dart';

import 'book.dart';

part 'book_search_result.freezed.dart';

// 도서 검색 결과 엔티티
// Book search result entity
@freezed
abstract class BookSearchResult with _$BookSearchResult {
  const factory BookSearchResult({
    required String id,
    required String title,
    String? author,
    String? publisher,
    String? pubDate,
    String? isbn13,
    String? cover,
    String? description,
    String? categoryName,
  }) = _BookSearchResult;

  // 외부 API JSON에서 검색 결과 생성 (id는 isbn13 → isbn → itemId 순으로 폴백)
  // Create search result from external API JSON (id falls back: isbn13 → isbn → itemId)
  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      id: json['isbn13']?.toString() ??
          json['isbn']?.toString() ??
          json['itemId']?.toString() ??
          '',
      title: json['title']?.toString() ?? '제목 없음',
      author: json['author']?.toString(),
      publisher: json['publisher']?.toString(),
      pubDate: json['pubdate']?.toString(), // 🔥 pubDate 아님 pubdate (key is lowercase 'pubdate', not 'pubDate')
      isbn13: json['isbn13']?.toString(),
      cover: json['cover']?.toString(),
      description: json['description']?.toString(),
      categoryName: json['categoryName']?.toString(),
    );
  }
}

// 검색 결과를 Book 엔티티로 변환하는 확장
// Extension to convert search result to a Book entity
extension BookSearchResultX on BookSearchResult {
  Book toBook({ReadingStatus status = ReadingStatus.reading}) => Book(
        id: id,
        title: title,
        author: author,
        publisher: publisher,
        pubDate: pubDate,
        isbn13: isbn13,
        coverUrl: cover,
        description: description,
        categoryName: categoryName,
        status: status,
        createdAt: DateTime.now(),
      );
}
