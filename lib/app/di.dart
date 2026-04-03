import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../feature/auth/data/auth_repository.dart';
import '../feature/book/data/book_repository.dart';

// Migration: Repositories declared as global Providers; replaces passing instances via ChangeNotifierProvider constructor
final authRepositoryProvider = Provider<AuthRepository>((ref) => AuthRepository());
final bookRepositoryProvider = Provider<BookRepository>((ref) => BookRepository());
