import 'book.dart';

class BookSearchResult {
  final String title;
  final String? author;
  final String? publisher;
  final String? pubDate;
  final String? isbn13;
  final String? cover;
  final String? description;
  final String? categoryName;

  const BookSearchResult({
    required this.title,
    this.author,
    this.publisher,
    this.pubDate,
    this.isbn13,
    this.cover,
    this.description,
    this.categoryName,
  });

  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      title: json['title'] as String,
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      pubDate: json['pubDate'] as String?,
      isbn13: json['isbn13'] as String?,
      cover: json['cover'] as String?,
      description: json['description'] as String?,
      categoryName: json['categoryName'] as String?,
    );
  }

  Book toBook({ReadingStatus status = ReadingStatus.reading}) => Book(
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
