# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Greenie is a Flutter mobile app for managing golf leagues. It tracks courses, rounds, leagues, members, and player scorecards with interactive score entry, skins, and handicap calculations. The app uses fake/mock data repositories (no backend yet).

A plan for the project has been written to @plan.md.

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

The app uses a **layered architecture** organized by feature domain:

```
lib/
├── main.dart                 # Entry point, wraps app with ProviderScope
├── app/core/                 # Routing (GoRouter), theme, shared enums, extensions
├── app/presentation/         # App-level screens (HomeScreen) and shared components
├── course/                   # Course feature domain
│   ├── infrastructure/       # Models (CourseModel, HoleModel), repository
│   ├── presentation/         # Scorecard components (score_cell, scorecard_row, etc.)
│   └── course_providers.dart # Riverpod providers
├── league/                   # League feature domain (same structure)
├── round/                    # Round feature domain (round management, score entry, leaderboard)
└── user/                     # User/member feature domain (user model, member model)
```

**Key patterns:**
- **State management**: Riverpod with code generation (`@riverpod` annotations → `*.g.dart` files)
- **Data access**: Repository pattern with abstract base classes and fake implementations
- **Navigation**: GoRouter with generated route helpers (`routing.g.dart`)
- **Async data**: `AsyncValue<T>` pattern in providers, `switch` on state in UI

**Provider dependency chain:**
```
UI (ConsumerWidget) → fetchX providers → repository providers → FakeRepository
```

## Key Conventions

- Generated files use the `part 'filename.g.dart'` pattern — never edit `*.g.dart` files directly
- Repositories are provided via Riverpod (no separate DI container)
- Theme uses a green primary color (`0xFF26BD00`) with brand colors and spacing scale defined in `lib/app/core/theme.dart`
- No need to run `flutter pub get` after installing packages — the IDE does this automatically
- Ignore generated `*.g.dart` files when measuring test coverage