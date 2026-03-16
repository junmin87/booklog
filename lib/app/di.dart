import 'package:provider/provider.dart';

import '../feature/book/data/book_repository.dart';
import '../feature/book/presentation/provider/book_provider.dart';

final appProviders = [
  ChangeNotifierProvider(create: (_) => BookProvider(BookRepository())),
];
