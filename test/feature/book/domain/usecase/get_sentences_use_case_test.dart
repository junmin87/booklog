import 'package:book_log/feature/book/domain/entity/sentence.dart';
import 'package:book_log/feature/book/domain/repository/sentence_repository.dart';
import 'package:book_log/feature/book/domain/usecase/get_sentences_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SentenceRepository])
import 'get_sentences_use_case_test.mocks.dart';

void main() {
  late MockSentenceRepository mockRepository;
  late GetSentencesUseCase useCase;

  setUp(() {
    mockRepository = MockSentenceRepository();
    useCase = GetSentencesUseCase(mockRepository);
  });

  // repository에서 문장 목록을 반환한다
  // Returns list of Sentences from repository
  test('returns list of Sentences from repository', () async {
    final sentences = [
      Sentence(
        id: 's1',
        bookId: 'book_1',
        content: 'First sentence',
        pageNumber: 10,
        createdAt: DateTime(2024, 1, 1),
      ),
      Sentence(
        id: 's2',
        bookId: 'book_1',
        content: 'Second sentence',
        createdAt: DateTime(2024, 1, 2),
      ),
    ];

    when(mockRepository.getSentences('book_1'))
        .thenAnswer((_) async => sentences);

    final result = await useCase.execute('book_1');

    expect(result, equals(sentences));
    expect(result.length, equals(2));
    verify(mockRepository.getSentences('book_1')).called(1);
  });

  // repository가 빈 목록을 반환하면 빈 목록을 반환한다
  // Returns empty list when repository returns empty list
  test('returns empty list when repository returns empty list', () async {
    when(mockRepository.getSentences('book_99'))
        .thenAnswer((_) async => []);

    final result = await useCase.execute('book_99');

    expect(result, isEmpty);
    verify(mockRepository.getSentences('book_99')).called(1);
  });
}
