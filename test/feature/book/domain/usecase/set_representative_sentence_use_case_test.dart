import 'package:book_log/feature/book/domain/repository/sentence_repository.dart';
import 'package:book_log/feature/book/domain/usecase/set_representative_sentence_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

@GenerateMocks([SentenceRepository])
import 'set_representative_sentence_use_case_test.mocks.dart';

void main() {
  late MockSentenceRepository mockRepository;
  late SetRepresentativeSentenceUseCase useCase;

  setUp(() {
    mockRepository = MockSentenceRepository();
    useCase = SetRepresentativeSentenceUseCase(mockRepository);
  });

  // 올바른 파라미터로 repository.setRepresentative를 호출한다
  // Calls repository.setRepresentative with correct params
  test('calls repository.setRepresentative with correct bookId and sentenceId',
      () async {
    when(mockRepository.setRepresentative('book_1', 'sentence_5'))
        .thenAnswer((_) async {});

    await useCase.execute('book_1', 'sentence_5');

    verify(mockRepository.setRepresentative('book_1', 'sentence_5')).called(1);
  });
}
