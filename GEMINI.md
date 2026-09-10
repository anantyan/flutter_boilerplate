# GEMINI & AI Assistant Pairing Guide: `flutter_boilerplate`

This document outlines the architectural invariants, engineering conventions, and workflows required when interacting with or modifying the `flutter_boilerplate` codebase.

---

## 🧭 Core Architectural Invariants

### 1. Clean Architecture Layer Discipline
- **`lib/domain/` (Pure Dart Core)**:
  - **NEVER** import Flutter UI packages (`package:flutter/*`).
  - **NEVER** import outer infrastructure packages (`dio`, `flutter_secure_storage`, `shared_preferences`, etc.).
  - Contains only **Entities**, **Repository Interfaces**, and **Use Cases**.
  - All use cases must have a single public `execute(...)` method and return `Future<Either<Failure, T>>`.

- **`lib/data/` (Data & Persistence)**:
  - Models (DTOs) reside in `lib/data/models/` and must provide `fromJson`, `toJson`, and `toEntity()`. Entities should not know about DTOs or JSON.
  - Data Sources in `lib/data/datasources/` make external calls and throw typed `NetworkException`s or `CacheException`s.
  - Repository Implementations in `lib/data/repositories/` catch data-level exceptions and map them into domain `Failure`s, returning `Either<Failure, T>`.

- **`lib/presentation/` (UI & Reactive State)**:
  - All business state is managed via `Bloc` (from `package:flutter_bloc`).
  - Events and States must extend `Equatable` and implement `props`.
  - State classes must be immutable. Use `copyWith` for updating state properties.
  - Do not call data sources or repositories directly from UI widgets; all access must flow through BLoC use case invocations.

- **`lib/common/` (Shared Cross-Cutting Infrastructure)**:
  - `errors/`: Domain `Failure` and data `NetworkException` sealed classes.
  - `network/`: Dio client factory and error handling interceptors.
  - `storage/`: `ISecureStorageService` interface and implementation.
  - `theme/`: Material 3 design tokens (`AppColors`, `AppTextStyles`, `AppTheme`).
  - `router/`: AutoRoute `AppRouter` configuration.

---

## ⚙️ Dependency Injection & Code Generation Rules

1. **Service Locator**: `GetIt` configured via `injectable`.
   - Register dependencies using annotations:
     - `@lazySingleton` for shared, single-instance services (e.g. `AppRouter`, `ThemeBloc`, data sources).
     - `@LazySingleton(as: Interface)` when registering a concrete class against an abstract contract (e.g. `PostRepositoryImpl` as `PostRepository`).
     - `@injectable` or `@factory` for use cases and transient blocs.
     - Third-party instances belong in `lib/di/modules/register_module.dart` with `@module`.
2. **AutoRoute Navigation**:
   - Every routable screen must be annotated with `@RoutePage()`.
   - Add the generated route symbol to `AppRouter.routes` in `lib/common/router/app_router.dart`.
3. **Build Runner Command**:
   - Always re-generate after modifying annotated classes:
     ```bash
     dart run build_runner build --delete-conflicting-outputs
     ```

---

## 🛡️ Error Handling & Monads

- **Functional Monads**: Use `dartz` `Either<Failure, T>`.
  - `Left(Failure)` indicates business/network failure.
  - `Right(T)` indicates success.
- **Handling in BLoCs**:
  ```dart
  final result = await _useCase.execute();
  result.fold(
    (failure) => emit(StateFailure(failure.message)),
    (data) => emit(StateSuccess(data)),
  );
  ```
- **Never swallow errors**: Every unexpected catch block must map to a descriptive `Failure`.

---

## 🧪 Testing Guidelines

Every code modification must be accompanied by automated tests:
1. **Use Cases**: Test success and failure paths using `Mock` classes from `mocktail`.
2. **Repositories**: Test mapping from data sources to domain models and exception-to-failure conversion.
3. **BLoCs**: Use `blocTest` from `bloc_test` asserting emitted states sequentially.
4. **Widgets & Screens**: Use `testWidgets` with `MultiBlocProvider` providing mock blocs to verify rendered widgets and gesture interactions.
5. **Running Test Verification**:
   ```bash
   flutter test
   dart analyze
   dart format --set-exit-if-changed .
   ```

---

## 📝 Code Style & Conventions

- Strictly follow `flutter_lints`.
- Use trailing commas for all multi-line widget and constructor declarations.
- Enforce 80-character formatting width via `dart format`.
- Use explicit type annotations for public APIs and function returns.
- Keep widgets modular and decomposed; avoid monolithic `build` methods over 80 lines.
