import 'package:book_log/feature/book/domain/entity/book.dart';
import 'package:book_log/feature/book/domain/entity/book_search_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BookSearchResult.fromJson', () {
    // 모든 필드가 포함된 정상 JSON에서 올바르게 파싱되는지 검증
    // Verify correct parsing from a full JSON with all fields
    test('모든 필드가 포함된 정상 JSON을 올바르게 파싱한다', () {
      final json = {
        'isbn13': '9788972750000',
        'title': '해변의 카프카',
        'author': '무라카미 하루키',
        'publisher': '문학사상',
        'pubdate': '2003-01-01',
        'cover': 'https://example.com/cover.jpg',
        'description': '카프카의 이야기',
        'categoryName': '소설',
      };

      final result = BookSearchResult.fromJson(json);

      expect(result.id, '9788972750000');
      expect(result.title, '해변의 카프카');
      expect(result.author, '무라카미 하루키');
      expect(result.publisher, '문학사상');
      expect(result.pubDate, '2003-01-01');
      expect(result.isbn13, '9788972750000');
      expect(result.cover, 'https://example.com/cover.jpg');
      expect(result.description, '카프카의 이야기');
      expect(result.categoryName, '소설');
    });

    // id 폴백 로직: isbn13이 있으면 isbn13을 사용하는지 검증
    // ID fallback: verify isbn13 is used as id when available
    test('isbn13이 있으면 id로 isbn13을 사용한다', () {
      final json = {
        'isbn13': '978-isbn13',
        'isbn': '978-isbn',
        'itemId': 'item-1',
        'title': '테스트',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.id, '978-isbn13');
    });

    // id 폴백 로직: isbn13이 없으면 isbn을 사용하는지 검증
    // ID fallback: verify isbn is used when isbn13 is missing
    test('isbn13이 없으면 isbn을 사용한다', () {
      final json = {
        'isbn': '978-isbn',
        'itemId': 'item-1',
        'title': '테스트',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.id, '978-isbn');
    });

    // id 폴백 로직: isbn13과 isbn이 없으면 itemId를 사용하는지 검증
    // ID fallback: verify itemId is used when isbn13 and isbn are missing
    test('isbn13과 isbn이 없으면 itemId를 사용한다', () {
      final json = {
        'itemId': 'item-1',
        'title': '테스트',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.id, 'item-1');
    });

    // id 폴백 로직: 모든 id 후보가 없으면 빈 문자열이 되는지 검증
    // ID fallback: verify empty string when all id candidates are missing
    test('id 후보가 모두 없으면 빈 문자열이 된다', () {
      final json = {
        'title': '테스트',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.id, '');
    });

    // 키 이름이 pubdate(소문자)여야 하고 pub_date가 아닌지 검증
    // Verify lowercase 'pubdate' key is used, not 'pub_date'
    test('pubdate 키를 사용하며 pub_date는 무시한다', () {
      final json = {
        'isbn13': '978-test',
        'title': '테스트',
        'pubdate': '2025-01-01',
        'pub_date': '1999-12-31',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.pubDate, '2025-01-01');
    });

    // pub_date 키만 있으면 pubDate가 null이 되는지 검증
    // Verify pubDate is null when only 'pub_date' key exists (not 'pubdate')
    test('pub_date 키만 있으면 pubDate는 null이다', () {
      final json = {
        'isbn13': '978-test',
        'title': '테스트',
        'pub_date': '2025-01-01',
      };

      final result = BookSearchResult.fromJson(json);
      expect(result.pubDate, isNull);
    });
  });

  group('BookSearchResult.toBook', () {
    // toBook() 변환 시 필드가 올바르게 매핑되는지 검증
    // Verify fields are correctly mapped when converting via toBook()
    test('toBook() 변환 시 필드가 올바르게 매핑된다', () {
      final searchResult = BookSearchResult(
        id: 'isbn-123',
        title: '테스트 책',
        author: '저자',
        publisher: '출판사',
        pubDate: '2025-01-01',
        isbn13: 'isbn-123',
        cover: 'https://example.com/cover.jpg',
        description: '설명',
        categoryName: '소설',
      );

      final book = searchResult.toBook(status: ReadingStatus.finished);

      expect(book.id, 'isbn-123');
      expect(book.title, '테스트 책');
      expect(book.author, '저자');
      expect(book.publisher, '출판사');
      expect(book.pubDate, '2025-01-01');
      expect(book.isbn13, 'isbn-123');
      expect(book.coverUrl, 'https://example.com/cover.jpg');
      expect(book.description, '설명');
      expect(book.categoryName, '소설');
      expect(book.status, ReadingStatus.finished);
    });

    // toBook() 기본 status가 reading인지 검증
    // Verify default status from toBook() is 'reading'
    test('toBook() 기본 status는 reading이다', () {
      final searchResult = BookSearchResult(
        id: 'isbn-123',
        title: '테스트',
      );

      final book = searchResult.toBook();
      expect(book.status, ReadingStatus.reading);
    });
  });
}
