import 'package:book_log/l10n/app_localizations.dart';

import '../../domain/entity/book.dart';

// ReadingStatus → 현지화된 라벨
// ReadingStatus → localized label
extension ReadingStatusLabel on ReadingStatus {
  String label(AppLocalizations l10n) {
    switch (this) {
      case ReadingStatus.wantToRead:
        return l10n.bookStatusWantToRead;
      case ReadingStatus.reading:
        return l10n.bookStatusReading;
      case ReadingStatus.finished:
        return l10n.bookStatusCompleted;
    }
  }
}
