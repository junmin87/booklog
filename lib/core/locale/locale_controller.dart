import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Migration: Notifier replaces ChangeNotifier; state is returned from build() instead of mutated fields
class LocaleNotifier extends Notifier<Locale?> {
  @override
  Locale? build() => null;
}

final localeNotifierProvider = NotifierProvider<LocaleNotifier, Locale?>(LocaleNotifier.new);
