import 'package:book_log/feature/book/domain/repository/sentence_repository.dart';
import 'package:book_log/feature/book/domain/usecase/add_sentence_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SentenceRepository])
import 'add_sentence_use_case_test.mocks.dart';

void main() {
  late MockSentenceRepository mockRepository;
  late AddSentenceUseCase useCase;

  setUp(() {
    mockRepository = MockSentenceRepository();
    useCase = AddSentenceUseCase(mockRepository);
  });

  // 올바른 파라미터로 repository.addSentence를 호출한다
  // Calls repository.addSentence with correct params
  test('calls repository.addSentence with correct params', () async {
    when(mockRepository.addSentence('book_1', 'A great sentence',
            pageNumber: 42))
        .thenAnswer((_) async {});

    await useCase.execute('book_1', 'A great sentence', pageNumber: 42);

    verify(mockRepository.addSentence('book_1', 'A great sentence',
            pageNumber: 42))
        .called(1);
  });

  // pageNumber 없이 repository.addSentence를 호출한다
  // Calls repository.addSentence without pageNumber
  test('calls repository.addSentence without pageNumber', () async {
    when(mockRepository.addSentence('book_2', 'Another sentence'))
        .thenAnswer((_) async {});

    await useCase.execute('book_2', 'Another sentence');

    verify(mockRepository.addSentence('book_2', 'Another sentence')).called(1);
  });
}
