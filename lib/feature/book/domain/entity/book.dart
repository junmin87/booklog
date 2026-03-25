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
}

class Book {
  final int? id;
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
    required this.createdAt,
  });
}
