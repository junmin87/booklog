import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
import '../core/service/push_service.dart';
import '../feature/auth/data/auth_repository.dart';
import '../feature/book/data/book_repository_impl.dart';
import '../feature/book/data/sentence_repository_impl.dart';
import '../feature/book/domain/repository/book_repository.dart';
import '../feature/book/domain/repository/sentence_repository.dart';
import '../feature/book/domain/usecase/add_book_use_case.dart';
import '../feature/book/domain/usecase/add_sentence_use_case.dart';
import '../feature/book/domain/usecase/get_books_use_case.dart';
import '../feature/book/domain/usecase/get_sentences_use_case.dart';
import '../feature/book/domain/usecase/set_representative_sentence_use_case.dart';


final pushServiceProvider = Provider<PushService>((ref) => PushService());

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());


final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(apiClient: ref.watch(apiClientProvider)),
);

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final sentenceRepositoryProvider = Provider<SentenceRepository>(
  (ref) => SentenceRepositoryImpl(apiClient: ref.watch(apiClientProvider)),
);

final addBookUseCaseProvider = Provider<AddBookUseCase>(
  (ref) => AddBookUseCase(ref.watch(bookRepositoryProvider)),
);

final getBooksUseCaseProvider = Provider<GetBooksUseCase>(
  (ref) => GetBooksUseCase(ref.watch(bookRepositoryProvider)),
);

final addSentenceUseCaseProvider = Provider<AddSentenceUseCase>(
  (ref) => AddSentenceUseCase(ref.watch(sentenceRepositoryProvider)),
);

final getSentencesUseCaseProvider = Provider<GetSentencesUseCase>(
  (ref) => GetSentencesUseCase(ref.watch(sentenceRepositoryProvider)),
);

final setRepresentativeSentenceUseCaseProvider =
    Provider<SetRepresentativeSentenceUseCase>(
  (ref) =>
      SetRepresentativeSentenceUseCase(ref.watch(sentenceRepositoryProvider)),
);
