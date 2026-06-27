import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';

// 독서 상태 열거형
// Reading status enum
enum ReadingStatus { wantToRead, reading, finished }

// ReadingStatus ↔ 서버 API 값 변환
// ReadingStatus ↔ server API value conversion
extension ReadingStatusX on ReadingStatus {
  // 서버에 보낼 API 문자열 값
  // API string value to send to server
  String get apiValue {
    switch (this) {
      case ReadingStatus.wantToRead:
        return 'want_to_read';
      case ReadingStatus.reading:
        return 'reading';
      case ReadingStatus.finished:
        return 'completed';
    }
  }

  // 서버 API 값에서 ReadingStatus로 변환 (알 수 없는 값은 wantToRead)
  // Convert from server API value to ReadingStatus (unknown values default to wantToRead)
  static ReadingStatus fromApiValue(String value) {
    switch (value) {
      case 'reading':
        return ReadingStatus.reading;
      case 'completed':
        return ReadingStatus.finished;
      default:
        return ReadingStatus.wantToRead;
    }
  }
}

// 책 엔티티
// Book entity
@freezed
abstract class Book with _$Book {
  const factory Book({
    required String id,
    required String title,
    String? author,
    String? publisher,
    @JsonKey(name: 'pub_date') String? pubDate,
    String? isbn13,
    @JsonKey(name: 'cover_url') String? coverUrl,
    String? description,
    @JsonKey(name: 'category_name') String? categoryName,
    @Default(ReadingStatus.wantToRead) ReadingStatus status,
    int? rating,
    String? notes,
    @JsonKey(name: 'current_page') int? currentPage,
    @JsonKey(name: 'total_page') int? totalPage,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'representative_sentence') String? representativeSentence,
  }) = _Book;

  // 서버 JSON 응답에서 Book 객체 생성
  // Create Book from server JSON response
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
