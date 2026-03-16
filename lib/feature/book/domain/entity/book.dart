enum ReadingStatus { wantToRead, reading, finished }

class Book {
  final int? id;
  final String title;
  final String? author;
  final ReadingStatus status;
  final int? rating; // 1–5
  final String? notes;
  final DateTime createdAt;

  const Book({
    this.id,
    required this.title,
    this.author,
    this.status = ReadingStatus.wantToRead,
    this.rating,
    this.notes,
    required this.createdAt,
  });
}
