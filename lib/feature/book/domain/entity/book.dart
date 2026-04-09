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
  final String id;
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
  final String? representativeSentence;

  const Book({
    required this.id,
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
    this.representativeSentence,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    debugPrint('Book.fromJson >>> $json');

    final id = json['id']?.toString() ?? '';
    if (id.isEmpty) {
      throw Exception('Book id is empty');
    }

    return Book(
      id: id,
      title: json['title']?.toString() ?? '제목 없음',
      author: json['author']?.toString(),
      publisher: json['publisher']?.toString(),
      pubDate: json['pub_date']?.toString(),
      isbn13: json['isbn13']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      description: json['description']?.toString(),
      categoryName: json['category_name']?.toString(),
      status: ReadingStatusX.fromApiValue(json['status']?.toString() ?? ''),
      rating: json['rating'] == null
          ? null
          : (json['rating'] is int
          ? json['rating'] as int
          : int.tryParse(json['rating'].toString())),
      notes: json['notes']?.toString(),
      currentPage: json['current_page'] == null
          ? null
          : (json['current_page'] is int
          ? json['current_page'] as int
          : int.tryParse(json['current_page'].toString())),
      totalPage: json['total_page'] == null
          ? null
          : (json['total_page'] is int
          ? json['total_page'] as int
          : int.tryParse(json['total_page'].toString())),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      representativeSentence: json['representative_sentence']?.toString(),
    );
  }
}