class Sentence {
  final String id;
  final String bookId;
  final String content;
  final int? pageNumber;
  final DateTime createdAt;

  const Sentence({
    required this.id,
    required this.bookId,
    required this.content,
    this.pageNumber,
    required this.createdAt,
  });

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
