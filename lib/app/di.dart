import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/network/api_client.dart';
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

final apiClientProvider = Provider<ApiClient>((ref) => ApiClient());

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final bookRepositoryProvider = Provider<BookRepository>(
  (ref) => BookRepositoryImpl(apiClient: ref.read(apiClientProvider)),
);

final sentenceRepositoryProvider = Provider<SentenceRepository>(
  (ref) => SentenceRepositoryImpl(apiClient: ref.read(apiClientProvider)),
);

final addBookUseCaseProvider = Provider<AddBookUseCase>(
  (ref) => AddBookUseCase(ref.read(bookRepositoryProvider)),
);

final getBooksUseCaseProvider = Provider<GetBooksUseCase>(
  (ref) => GetBooksUseCase(ref.read(bookRepositoryProvider)),
);

final addSentenceUseCaseProvider = Provider<AddSentenceUseCase>(
  (ref) => AddSentenceUseCase(ref.read(sentenceRepositoryProvider)),
);

final getSentencesUseCaseProvider = Provider<GetSentencesUseCase>(
  (ref) => GetSentencesUseCase(ref.read(sentenceRepositoryProvider)),
);

final setRepresentativeSentenceUseCaseProvider =
    Provider<SetRepresentativeSentenceUseCase>(
  (ref) =>
      SetRepresentativeSentenceUseCase(ref.read(sentenceRepositoryProvider)),
);
