import 'package:book_log/l10n/app_localizations.dart';

abstract final class Validators {
  /// Trims value, rejects empty/whitespace-only, rejects over 500 characters.
  static String? sentence(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return l10n.sentenceRequired;
    if (trimmed.length > 500) return l10n.sentenceTooLong;
    return null;
  }

  /// Optional field — passes if empty; rejects non-numeric or non-positive integers.
  static String? pageNumber(String? value, AppLocalizations l10n) {
    final trimmed = value?.trim() ?? '';
    if (trimmed.isEmpty) return null;
    final n = int.tryParse(trimmed);
    if (n == null || n <= 0) return l10n.pageNumberOnly;
    return null;
  }

  /// Trims value and rejects empty/whitespace-only queries.
  /// Returns null if valid, non-null if empty.
  static String? searchQuery(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? '' : null;
  }
}
