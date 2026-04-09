import '../repository/sentence_repository.dart';

class SetRepresentativeSentenceUseCase {
  const SetRepresentativeSentenceUseCase(this._repository);

  final SentenceRepository _repository;

  Future<void> execute(String bookId, String sentenceId) =>
      _repository.setRepresentative(bookId, sentenceId);
}
