import '../entity/sentence.dart';
import '../repository/sentence_repository.dart';

class GetSentencesUseCase {
  const GetSentencesUseCase(this._repository);

  final SentenceRepository _repository;

  Future<List<Sentence>> execute(String bookId) async {
    return _repository.getSentences(bookId);
  }
}
