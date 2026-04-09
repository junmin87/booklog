import 'package:flutter/cupertino.dart';

import 'book.dart';

class BookSearchResult {
  final String id;
  final String title;
  final String? author;
  final String? publisher;
  final String? pubDate;
  final String? isbn13;
  final String? cover;
  final String? description;
  final String? categoryName;

  const BookSearchResult({
    required this.id,
    required this.title,
    this.author,
    this.publisher,
    this.pubDate,
    this.isbn13,
    this.cover,
    this.description,
    this.categoryName,
  });

  // factory BookSearchResult.fromJson(Map<String, dynamic> json) {
  //   return BookSearchResult(
  //     id: json['id'] as String,
  //     title: json['title'] as String,
  //     author: json['author'] as String?,
  //     publisher: json['publisher'] as String?,
  //     pubDate: json['pubDate'] as String?,
  //     isbn13: json['isbn13'] as String?,
  //     cover: json['cover'] as String?,
  //     description: json['description'] as String?,
  //     categoryName: json['categoryName'] as String?,
  //   );
  // }

  // factory BookSearchResult.fromJson(Map<String, dynamic> json) {
  //   debugPrint('BookSearchResult.fromJson >>> $json');
  //
  //   return BookSearchResult(
  //     id: json['id']?.toString() ?? json['isbn13']?.toString() ?? '',
  //     title: json['title']?.toString() ?? '제목 없음',
  //     author: json['author']?.toString(),
  //     publisher: json['publisher']?.toString(),
  //     pubDate: json['pubDate']?.toString(),
  //     isbn13: json['isbn13']?.toString(),
  //     cover: json['cover']?.toString(),
  //     description: json['description']?.toString(),
  //     categoryName: json['categoryName']?.toString(),
  //   );
  // }

  factory BookSearchResult.fromJson(Map<String, dynamic> json) {
    return BookSearchResult(
      id: json['isbn13']?.toString() ??
          json['isbn']?.toString() ??
          json['itemId']?.toString() ??
          '',
      title: json['title']?.toString() ?? '제목 없음',
      author: json['author']?.toString(),
      publisher: json['publisher']?.toString(),
      pubDate: json['pubdate']?.toString(), // 🔥 pubDate 아님 pubdate
      isbn13: json['isbn13']?.toString(),
      cover: json['cover']?.toString(),
      description: json['description']?.toString(),
      categoryName: json['categoryName']?.toString(),
    );
  }

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
