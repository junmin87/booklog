import 'package:book_log/feature/book/domain/entity/sentence.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Sentence.fromJson', () {
    // 모든 필드가 포함된 정상 JSON(snake_case 키)에서 올바르게 파싱되는지 검증
    // Verify correct parsing from a full JSON with snake_case keys
    test('모든 필드가 포함된 정상 JSON을 올바르게 파싱한다', () {
      final json = {
        'id': 'sentence-1',
        'book_id': 'book-1',
        'content': '인생은 속도가 아니라 방향이다.',
        'page_number': 42,
        'created_at': '2025-03-15T09:00:00.000Z',
      };

      final sentence = Sentence.fromJson(json);

      expect(sentence.id, 'sentence-1');
      expect(sentence.bookId, 'book-1');
      expect(sentence.content, '인생은 속도가 아니라 방향이다.');
      expect(sentence.pageNumber, 42);
      expect(sentence.createdAt, DateTime.parse('2025-03-15T09:00:00.000Z'));
    });

    // page_number가 String 타입일 때 int로 변환되는지 검증
    // Verify page_number is parsed from String to int
    test('page_number가 String이면 int로 변환한다', () {
      final json = {
        'id': 'sentence-2',
        'book_id': 'book-1',
        'content': '명문장',
        'page_number': '100',
        'created_at': '2025-03-15T09:00:00.000Z',
      };

      final sentence = Sentence.fromJson(json);

      expect(sentence.pageNumber, 100);
    });

    // page_number가 null일 때 null로 설정되는지 검증
    // Verify page_number is set to null when value is null
    test('page_number가 null이면 null로 설정된다', () {
      final json = {
        'id': 'sentence-3',
        'book_id': 'book-1',
        'content': '명문장',
        'page_number': null,
        'created_at': '2025-03-15T09:00:00.000Z',
      };

      final sentence = Sentence.fromJson(json);

      expect(sentence.pageNumber, isNull);
    });
  });
}
