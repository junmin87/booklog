import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/sentence.dart';

class SentenceNotifier extends FamilyAsyncNotifier<List<Sentence>, String> {
  @override
  Future<List<Sentence>> build(String bookId) async {
    return ref.read(getSentencesUseCaseProvider).execute(bookId);
  }

  Future<void> addSentence(String bookId, String content,
      {int? pageNumber}) async {
    debugPrint('add sentence bookId : ${bookId}');

    await ref
        .read(addSentenceUseCaseProvider)
        .execute(bookId, content, pageNumber: pageNumber);
    ref.invalidateSelf();
  }
}

final sentenceNotifierProvider = AsyncNotifierProvider.family<SentenceNotifier,
    List<Sentence>, String>(SentenceNotifier.new);
