import '../entity/book.dart';
import '../repository/book_repository.dart';

class GetBooksUseCase {
  const GetBooksUseCase(this._repository);

  final BookRepository _repository;

  Future<List<Book>> execute() async {
    return _repository.getBooks();
  }
}
