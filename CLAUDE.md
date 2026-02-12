# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Greenie is a Flutter mobile app for managing golf leagues. It tracks courses, leagues, and player scorecards. The app is in early development (v0.0.1) using fake/mock data repositories.

## Common Commands

```bash
# Run the app
flutter run

# Run tests
flutter test

# Run a single test file
flutter test test/path_to_test.dart

# Static analysis
flutter analyze

# Code generation (Riverpod providers)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for code generation
dart run build_runner watch --delete-conflicting-outputs
```

## Architecture

The app uses a **layered architecture** organized by feature domain (`course/`, `league/`, `user/`):

```
lib/
├── main.dart                 # Entry point, wraps app with ProviderScope
├── app/core/                 # Routing (GoRouter), theme, shared enums
├── app/presentation/         # App-level screens (HomeScreen)
├── course/                   # Course feature domain
│   ├── infrastructure/       # Models, repository (abstract + fake impl)
│   ├── presentation/         # Screens and components (scorecard)
│   └── course_providers.dart # Riverpod providers
├── league/                   # League feature domain
│   └── (same structure)
└── user/                     # User feature domain (stub)
```

**Key patterns:**
- **State management**: Riverpod with code generation (`@riverpod` annotations → `*.g.dart` files)
- **Data access**: Repository pattern with abstract base classes and fake implementations
- **Navigation**: GoRouter with generated route helpers (`routing.g.dart`)
- **Async data**: `AsyncValue<T>` pattern in providers, `switch` on state in UI

**Provider dependency chain:**
```
UI (ConsumerWidget) → fetchCourses/fetchLeagues providers → repository providers → FakeRepository
```

## Key Conventions

- Generated files use the `part 'filename.g.dart'` pattern — never edit `*.g.dart` files directly
- Repositories are provided via Riverpod (no separate DI container)
- `go_router` is listed under dev_dependencies in pubspec.yaml but used at runtime via the routing providers
- Theme uses a green primary color (`0xFF26BD00`)
