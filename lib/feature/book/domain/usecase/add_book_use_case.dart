import '../entity/book_search_result.dart';
import '../repository/book_repository.dart';

class AddBookUseCase {
  const AddBookUseCase(this._repository);

  final BookRepository _repository;

  Future<void> execute(BookSearchResult result) async {
    await _repository.addBook(result.toBook());
  }
}
