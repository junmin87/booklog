import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../feature/auth/data/auth_repository.dart';
import '../feature/book/data/book_repository_impl.dart';
import '../feature/book/data/sentence_repository_impl.dart';
import '../feature/book/domain/repository/book_repository.dart';
import '../feature/book/domain/repository/sentence_repository.dart';
import '../feature/book/domain/usecase/add_book_use_case.dart';
import '../feature/book/domain/usecase/add_sentence_use_case.dart';
import '../feature/book/domain/usecase/get_books_use_case.dart';
import '../feature/book/domain/usecase/get_sentences_use_case.dart';

final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository());

final bookRepositoryProvider =
    Provider<BookRepository>((ref) => BookRepositoryImpl());

final sentenceRepositoryProvider =
    Provider<SentenceRepository>((ref) => SentenceRepositoryImpl());

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
