import 'package:flutter/cupertino.dart';

enum ReadingStatus { wantToRead, reading, finished }

extension ReadingStatusX on ReadingStatus {
  String get apiValue {
    switch (this) {
      case ReadingStatus.wantToRead:
        return 'wish';
      case ReadingStatus.reading:
        return 'reading';
      case ReadingStatus.finished:
        return 'done';
    }
  }

  static ReadingStatus fromApiValue(String value) {
    switch (value) {
      case 'reading':
        return ReadingStatus.reading;
      case 'done':
        return ReadingStatus.finished;
      default:
        return ReadingStatus.wantToRead;
    }
  }
}

class Book {
  // final int? id;
  final String? id;
  final String title;
  final String? author;
  final String? publisher;
  final String? pubDate;
  final String? isbn13;
  final String? coverUrl;
  final String? description;
  final String? categoryName;
  final ReadingStatus status;
  final int? rating; // 1–5
  final String? notes;
  final int? currentPage;
  final int? totalPage;
  final DateTime createdAt;

  const Book({
    this.id,
    required this.title,
    this.author,
    this.publisher,
    this.pubDate,
    this.isbn13,
    this.coverUrl,
    this.description,
    this.categoryName,
    this.status = ReadingStatus.wantToRead,
    this.rating,
    this.notes,
    this.currentPage,
    this.totalPage,
    required this.createdAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    debugPrint('Book.fromJson >>> ${json}' );

    return Book(
      // id: json['id'] is int ? json['id'] as int : int.tryParse(json['id'].toString()),
      id: json['id']! as String,
      title: json['title'] as String,
      author: json['author'] as String?,
      publisher: json['publisher'] as String?,
      coverUrl: json['cover_url'] as String?,
      status: ReadingStatusX.fromApiValue(json['status'] as String? ?? ''),
      currentPage: json['current_page'] == null ? null : (json['current_page'] is int ? json['current_page'] as int : int.tryParse(json['current_page'].toString())),
      totalPage: json['total_page'] == null ? null : (json['total_page'] is int ? json['total_page'] as int : int.tryParse(json['total_page'].toString())),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
