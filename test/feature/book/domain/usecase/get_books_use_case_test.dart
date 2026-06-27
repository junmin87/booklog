import 'package:book_log/feature/book/domain/entity/book.dart';
import 'package:book_log/feature/book/domain/repository/book_repository.dart';
import 'package:book_log/feature/book/domain/usecase/get_books_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([BookRepository])
import 'get_books_use_case_test.mocks.dart';

void main() {
  late MockBookRepository mockRepository;
  late GetBooksUseCase useCase;

  setUp(() {
    mockRepository = MockBookRepository();
    useCase = GetBooksUseCase(mockRepository);
  });

  // repository에서 책 목록을 반환한다
  // Returns list of Books from repository
  test('returns list of Books from repository', () async {
    final books = [
      Book(
        id: '1',
        title: 'Book A',
        status: ReadingStatus.reading,
        createdAt: DateTime(2024, 1, 1),
      ),
      Book(
        id: '2',
        title: 'Book B',
        status: ReadingStatus.finished,
        createdAt: DateTime(2024, 2, 1),
      ),
    ];

    when(mockRepository.getBooks()).thenAnswer((_) async => books);

    final result = await useCase.execute();

    expect(result, equals(books));
    expect(result.length, equals(2));
    verify(mockRepository.getBooks()).called(1);
  });

  // repository가 빈 목록을 반환하면 빈 목록을 반환한다
  // Returns empty list when repository returns empty list
  test('returns empty list when repository returns empty list', () async {
    when(mockRepository.getBooks()).thenAnswer((_) async => []);

    final result = await useCase.execute();

    expect(result, isEmpty);
    verify(mockRepository.getBooks()).called(1);
  });
}
