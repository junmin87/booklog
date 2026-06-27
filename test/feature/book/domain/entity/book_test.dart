import 'package:book_log/feature/book/domain/entity/book.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Book.fromJson', () {
    // 모든 필드가 포함된 정상 JSON에서 Book 객체가 올바르게 생성되는지 검증
    // Verify Book is correctly created from a full JSON with all fields
    test('모든 필드가 포함된 정상 JSON을 올바르게 파싱한다', () {
      final json = {
        'id': 'book-1',
        'title': '해변의 카프카',
        'author': '무라카미 하루키',
        'publisher': '문학사상',
        'pub_date': '2003-01-01',
        'isbn13': '9788972750000',
        'cover_url': 'https://example.com/cover.jpg',
        'description': '카프카의 이야기',
        'category_name': '소설',
        'status': 'reading',
        'rating': 5,
        'notes': '좋은 책',
        'current_page': 150,
        'total_page': 500,
        'created_at': '2025-01-15T10:30:00.000Z',
        'representative_sentence': '명문장',
      };

      final book = Book.fromJson(json);

      expect(book.id, 'book-1');
      expect(book.title, '해변의 카프카');
      expect(book.author, '무라카미 하루키');
      expect(book.publisher, '문학사상');
      expect(book.pubDate, '2003-01-01');
      expect(book.isbn13, '9788972750000');
      expect(book.coverUrl, 'https://example.com/cover.jpg');
      expect(book.description, '카프카의 이야기');
      expect(book.categoryName, '소설');
      expect(book.status, ReadingStatus.reading);
      expect(book.rating, 5);
      expect(book.notes, '좋은 책');
      expect(book.currentPage, 150);
      expect(book.totalPage, 500);
      expect(book.createdAt, DateTime.parse('2025-01-15T10:30:00.000Z'));
      expect(book.representativeSentence, '명문장');
    });

    // 선택 필드가 null인 JSON에서 null 값이 올바르게 처리되는지 검증
    // Verify optional fields are set to null when missing from JSON
    test('선택 필드가 null이면 null로 설정된다', () {
      final json = {
        'id': 'book-2',
        'title': '제목',
        'created_at': '2025-06-01T00:00:00.000Z',
      };

      final book = Book.fromJson(json);

      expect(book.id, 'book-2');
      expect(book.title, '제목');
      expect(book.author, isNull);
      expect(book.publisher, isNull);
      expect(book.pubDate, isNull);
      expect(book.isbn13, isNull);
      expect(book.coverUrl, isNull);
      expect(book.description, isNull);
      expect(book.categoryName, isNull);
      expect(book.status, ReadingStatus.wantToRead);
      expect(book.rating, isNull);
      expect(book.notes, isNull);
      expect(book.currentPage, isNull);
      expect(book.totalPage, isNull);
      expect(book.representativeSentence, isNull);
    });

    // rating, currentPage, totalPage가 String 타입일 때 int로 변환되는지 검증
    // Verify rating/currentPage/totalPage are parsed from String to int
    test('rating/currentPage/totalPage가 String이면 int로 변환한다', () {
      final json = {
        'id': 'book-3',
        'title': '테스트',
        'rating': '4',
        'current_page': '100',
        'total_page': '300',
        'created_at': '2025-06-01T00:00:00.000Z',
      };

      final book = Book.fromJson(json);

      expect(book.rating, 4);
      expect(book.currentPage, 100);
      expect(book.totalPage, 300);
    });

    // id가 빈 문자열이면 예외가 발생하는지 검증
    // Verify exception is thrown when id is an empty string
    test('id가 빈 문자열이면 예외를 던진다', () {
      final json = {
        'id': '',
        'title': '테스트',
        'created_at': '2025-06-01T00:00:00.000Z',
      };

      expect(() => Book.fromJson(json), throwsException);
    });

    // id가 null이면 예외가 발생하는지 검증
    // Verify exception is thrown when id is null
    test('id가 null이면 예외를 던진다', () {
      final json = {
        'title': '테스트',
        'created_at': '2025-06-01T00:00:00.000Z',
      };

      expect(() => Book.fromJson(json), throwsException);
    });
  });

  group('ReadingStatus', () {
    // apiValue와 fromApiValue가 올바르게 왕복 변환되는지 검증
    // Verify round-trip conversion between apiValue and fromApiValue
    test('apiValue → fromApiValue 왕복 변환이 정확하다', () {
      for (final status in ReadingStatus.values) {
        final apiValue = status.apiValue;
        final restored = ReadingStatusX.fromApiValue(apiValue);
        expect(restored, status);
      }
    });

    // 각 enum 값의 apiValue가 서버 규약과 일치하는지 검증
    // Verify each enum's apiValue matches the server contract
    test('각 enum의 apiValue가 서버 규약과 일치한다', () {
      expect(ReadingStatus.wantToRead.apiValue, 'wish');
      expect(ReadingStatus.reading.apiValue, 'reading');
      expect(ReadingStatus.finished.apiValue, 'done');
    });

    // 알 수 없는 apiValue는 기본값 wantToRead로 매핑되는지 검증
    // Verify unknown apiValue defaults to wantToRead
    test('알 수 없는 apiValue는 wantToRead로 매핑된다', () {
      expect(ReadingStatusX.fromApiValue('unknown'), ReadingStatus.wantToRead);
      expect(ReadingStatusX.fromApiValue(''), ReadingStatus.wantToRead);
    });
  });
}
