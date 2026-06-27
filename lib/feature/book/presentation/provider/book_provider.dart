// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// import '../../../../app/di.dart';
// import '../../domain/entity/book.dart';
//
// class BookNotifier extends AsyncNotifier<List<Book>> {
//   @override
//   Future<List<Book>> build() async {
//     return ref.read(getBooksUseCaseProvider).execute();
//   }
// }
//
// final bookNotifierProvider =
//     AsyncNotifierProvider<BookNotifier, List<Book>>(BookNotifier.new);



import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/di.dart';
import '../../../auth/presentation/provider/auth_provider.dart';
import '../../domain/entity/book.dart';


class BookNotifier extends AsyncNotifier<List<Book>> {
  @override
  Future<List<Book>> build() async {
    final authState = ref.read(authNotifierProvider).valueOrNull;
    if (authState?.isGuest == true) return [];
    return ref.read(getBooksUseCaseProvider).execute();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => ref.read(getBooksUseCaseProvider).execute());
  }

  Future<void> updateStatus(String bookId, ReadingStatus status) async {
    await ref.read(updateBookStatusUseCaseProvider).execute(bookId, status);
    await refresh();
  }
}

final bookNotifierProvider =
AsyncNotifierProvider<BookNotifier, List<Book>>(BookNotifier.new);

