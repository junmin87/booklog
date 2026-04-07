import '../repository/sentence_repository.dart';

class AddSentenceUseCase {
  const AddSentenceUseCase(this._repository);

  final SentenceRepository _repository;

  Future<void> execute(String bookId, String content, {int? pageNumber}) async {
    await _repository.addSentence(bookId, content, pageNumber: pageNumber);
  }
}
