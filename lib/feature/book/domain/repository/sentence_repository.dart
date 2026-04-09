import '../entity/sentence.dart';

abstract class SentenceRepository {
  Future<void> addSentence(String bookId, String content, {int? pageNumber});
  Future<List<Sentence>> getSentences(String bookId);
  Future<void> setRepresentative(String bookId, String sentenceId);
}
