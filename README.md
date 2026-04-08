# 📚 Book Log

> The most beautiful way to save the sentences that stop you while reading

## Overview

An iOS app for saving meaningful sentences from books and turning them into shareable quote cards.
Solo developer project, currently in active development.

## Tech Stack

| Area | Stack |
|------|-------|
| Frontend | Flutter (iOS) |
| Backend | Node.js / Express / TypeScript |
| Database | Supabase (PostgreSQL) |
| Auth | Apple Sign In + JWT |
| Book Data | Aladin Open API |
| Infra | Google App Engine, Vercel |

## Architecture

### Flutter
- Feature-first clean architecture (`data / domain / presentation`)
- State management: Riverpod (AsyncNotifier)
- Domain layer with UseCase abstraction and Repository interface separation

### Backend
- RESTful API design
- JWT-based authentication with Supabase service role key for DB access
- Aladin Open API proxy

## Status

🚧 Active development
