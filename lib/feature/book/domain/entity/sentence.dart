import 'package:freezed_annotation/freezed_annotation.dart';

part 'sentence.freezed.dart';

// 책에서 발췌한 문장 엔티티
// Sentence entity (a passage saved from a book)
@freezed
abstract class Sentence with _$Sentence {
  const factory Sentence({
    required String id,
    @JsonKey(name: 'book_id') required String bookId,
    required String content,
    @JsonKey(name: 'page_number') int? pageNumber,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Sentence;

  // 서버 JSON 응답에서 Sentence 객체 생성
  // Create Sentence from server JSON response
  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      id: json['id'].toString(),
      bookId: json['book_id'].toString(),
      content: json['content'] as String,
      pageNumber: json['page_number'] == null
          ? null
          : (json['page_number'] is int
              ? json['page_number'] as int
              : int.tryParse(json['page_number'].toString())),
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
