import 'package:book_log/feature/book/domain/entity/book.dart';
import 'package:book_log/feature/book/domain/entity/book_search_result.dart';
import 'package:book_log/feature/book/domain/repository/book_repository.dart';
import 'package:book_log/feature/book/domain/usecase/add_book_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([BookRepository])
import 'add_book_use_case_test.mocks.dart';

void main() {
  late MockBookRepository mockRepository;
  late AddBookUseCase useCase;

  setUp(() {
    mockRepository = MockBookRepository();
    useCase = AddBookUseCase(mockRepository);
  });

  // 검색 결과를 Book으로 변환하여 repository.addBook을 호출한다
  // Converts BookSearchResult to Book and calls repository.addBook
  test('calls repository.addBook with correct Book converted from BookSearchResult',
      () async {
    final searchResult = BookSearchResult(
      id: '978-89-123',
      title: 'Flutter in Action',
      author: 'Eric Windmill',
      publisher: 'Manning',
      pubDate: '2020-01-01',
      isbn13: '978-89-123',
      cover: 'https://example.com/cover.jpg',
      description: 'A book about Flutter',
      categoryName: 'Programming',
    );

    when(mockRepository.addBook(any)).thenAnswer((_) async {});

    await useCase.execute(searchResult);

    final captured =
        verify(mockRepository.addBook(captureAny)).captured.single as Book;

    expect(captured.id, equals('978-89-123'));
    expect(captured.title, equals('Flutter in Action'));
    expect(captured.author, equals('Eric Windmill'));
    expect(captured.publisher, equals('Manning'));
    expect(captured.isbn13, equals('978-89-123'));
    expect(captured.coverUrl, equals('https://example.com/cover.jpg'));
    expect(captured.status, equals(ReadingStatus.reading));
  });
}
