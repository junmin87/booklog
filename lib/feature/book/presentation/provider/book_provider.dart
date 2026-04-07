import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di.dart';
import '../../domain/entity/book.dart';

class BookNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    return ref.read(getBooksUseCaseProvider).execute();
  }
}

final bookNotifierProvider =
    AsyncNotifierProvider<BookNotifier, List<Book>>(BookNotifier.new);
