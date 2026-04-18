# 📚 Book Log

**The most beautiful way to save the sentences that stop you while reading**

## Overview

An iOS app for saving meaningful sentences from books and turning them into shareable quote cards. Solo developer project, currently in active development.

## Tech Stack

| Area | Stack |
|------|-------|
| Frontend | Flutter (iOS, Android) |
| Backend | Node.js / Express / TypeScript |
| Database | Supabase (PostgreSQL) |
| Auth | Apple Sign In + JWT |
| Book Data | Aladin Open API |
| Push | Firebase Cloud Messaging (FCM) |
| Crash Reporting | Firebase Crashlytics |
| Infra | Google App Engine, Vercel |

## Architecture

### Flutter

- Feature-first clean architecture (`data / domain / presentation`)
- State management: Riverpod (AsyncNotifier)
- Network: Dio with custom interceptors (auth token injection, Crashlytics error logging)
- Domain layer with UseCase abstraction and Repository interface separation

### Backend

- RESTful API design
- JWT-based authentication with Supabase service role key for DB access
- Firebase Admin SDK for push notification management
- Aladin Open API proxy

## Testing

- Unit tests with `mockito`, `http_mock_adapter`
- ApiClient: interceptor behavior, token injection, error handling, HTTP methods
- AuthRepository: token validation, user retrieval, FCM token management, country settings

## Key Engineering Decisions

- **http → Dio migration**: Centralized error tracking via Crashlytics interceptor. All API failures are automatically recorded regardless of try-catch handling.
- **Provider → Riverpod migration**: Replaced ChangeNotifier with AsyncNotifier for cleaner async state management.
- **FCM integration**: Token registration/deletion wired into auth flow (login, logout, account deletion).

## Status

🚧 Active development

## Contact

junmin.lee15@gmail.com
