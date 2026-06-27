import '../entity/book.dart';
import '../repository/book_repository.dart';

class UpdateBookStatusUseCase {
  const UpdateBookStatusUseCase(this._repository);

  final BookRepository _repository;

  Future<void> execute(String bookId, ReadingStatus status) =>
      _repository.updateStatus(bookId, status);
}
