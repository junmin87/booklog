import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/sentence.dart';
import 'book_provider.dart';

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
    ref.read(bookNotifierProvider.notifier).refresh();  // 이거 추가
  }

  Future<void> setRepresentative(String bookId, String sentenceId) async {
    await ref
        .read(setRepresentativeSentenceUseCaseProvider)
        .execute(bookId, sentenceId);
    ref.invalidateSelf();
    // ref.invalidate(bookNotifierProvider);
    ref.read(bookNotifierProvider.notifier).refresh();
  }
}

final sentenceNotifierProvider = AsyncNotifierProvider.family<SentenceNotifier,
    List<Sentence>, String>(SentenceNotifier.new);
