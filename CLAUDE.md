# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**book_log** is a Flutter mobile app for tracking books and reading stats. It targets Android and iOS, with Firebase backend integration.

**Flutter version:** 3.29.2 (managed via FVM — use `fvm flutter` or ensure the correct version is active)

## Common Commands

```bash
flutter pub get          # Install dependencies
flutter analyze          # Run linter
flutter test             # Run all tests
flutter test test/widget_test.dart  # Run a single test file
flutter run              # Run in debug mode
flutter build apk        # Build Android APK
flutter build ipa        # Build iOS IPA
```

For iOS native dependency updates:
```bash
cd ios && pod install
```

## Architecture

The app uses a **feature-first Clean Architecture** layout under `lib/`:

- `main.dart` — App entry point. Implements a `ShellPage` with a bottom navigation bar (4 tabs: Home, Books, Stats, Settings). Uses `IndexedStack` + per-tab `GlobalKey<NavigatorState>` to preserve tab state. Root navigator handles full-screen detail pages without the bottom bar.
- `app/` — App-level setup: DI (`di.dart`), routing (`routes.dart`), theming (`theme.dart`), localization (`l10n/`).
- `core/` — Shared utilities and widgets used across features. `locale/locale_controller.dart` manages locale state with `provider`.
- `feature/<name>/` — Each feature is split into:
  - `data/` — repositories, data sources (SQLite via `sqflite`, Firestore via `cloud_firestore`)
  - `domain/` — entities, use cases
  - `presentation/` — widgets, screens, state (using `provider`)

## Key Dependencies

| Area | Package |
|------|---------|
| State management | `provider` |
| Local DB | `sqflite` |
| Cloud DB | `cloud_firestore` |
| Auth | `google_sign_in`, `sign_in_with_apple` |
| Firebase | `firebase_core`, `firebase_messaging`, `firebase_crashlytics`, `firebase_analytics`, `firebase_remote_config` |
| Secure storage | `flutter_secure_storage` |
| Localization | `intl`, `flutter_localization` |
| Environment vars | `flutter_dotenv` (requires `.env` file at project root — not committed) |

## Notes

- Comments in `main.dart` are in Korean.
- The app ID is `com.booking.app.book_log`.
- Most feature modules (`stats/`, `setting/`, `book/`) are currently skeletal — `data/` and `domain/` layers need implementation as features are built out.



## Engineering Principles

- Always consider potential side effects when modifying code.
- Prefer designs that allow new features to be added without modifying existing code whenever possible.
- Minimize changes to existing files when implementing new functionality.
- Avoid introducing tight coupling between feature modules.
- Keep dependencies between modules minimal and explicit.
- Prefer isolated changes within a feature rather than cross-module edits.
- Do not modify unrelated files unless strictly necessary.
- Maintain clear boundaries between data, domain, and presentation layers.
- Prefer extension over modification when designing solutions.
- Prefer minimal external dependencies. Avoid adding new packages unless they provide clear value.
- Favor simple and maintainable solutions over complex engineering techniques.