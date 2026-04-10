import '../../../core/network/api_client.dart';
import '../domain/entity/sentence.dart';
import '../domain/repository/sentence_repository.dart';

class SentenceRepositoryImpl implements SentenceRepository {
  SentenceRepositoryImpl({required ApiClient apiClient}) : _api = apiClient;

  final ApiClient _api;

  @override
  Future<void> addSentence(String bookId, String content,
      {int? pageNumber}) async {
    await _api.post(
      '/books/$bookId/sentences',
      {
        'content': content,
        if (pageNumber != null) 'pageNumber': pageNumber,
      },
      successCodes: [200, 201],
    );
  }

  @override
  Future<void> setRepresentative(String bookId, String sentenceId) async {
    await _api.patch(
      '/books/$bookId/sentences/$sentenceId/representative',
      successCodes: [200, 204],
    );
  }

  @override
  Future<List<Sentence>> getSentences(String bookId) async {
    final data = await _api.get('/books/$bookId/sentences');
    final sentences = data['sentences'] as List<dynamic>;
    return sentences
        .map((s) => Sentence.fromJson(s as Map<String, dynamic>))
        .toList();
  }
}
