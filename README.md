# Flutter Boilerplate (`flutter_boilerplate`)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Architecture](https://img.shields.io/badge/Architecture-Clean%20Architecture-4CAF50)](DESIGN.md)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

A battle-tested, enterprise-grade Flutter starter template engineered for rapid, scalable production application development. Built with **Clean Architecture**, **BLoC Pattern**, compile-time **Dependency Injection**, declarative **AutoRoute navigation**, encrypted hardware-backed storage, and **Functional Error Handling** via `Either<Failure, T>`.

---

## 🏛️ Architecture Overview

The codebase strictly adheres to **Uncle Bob's Clean Architecture** with unidirectional data flow and inversion of control. The business rules depend on nothing, while outer layers depend inward on abstract domain interfaces.

```mermaid
graph TD
    subgraph Presentation Layer
        UI[Widgets & Screens] -->|Events| BLOC[ThemeBloc / PostBloc]
        BLOC -->|States| UI
    end

    subgraph Domain Layer - Pure Dart
        BLOC -->|Executes| UC[UseCases]
        UC -->|Calls| REPO_INTERFACE[Repository Interfaces]
        UC -->|Uses| ENTITY[Domain Entities]
    end

    subgraph Data Layer
        REPO_IMPL[Repository Implementations] -->|Implements| REPO_INTERFACE
        REPO_IMPL -->|Fetches / Saves| REMOTE_DS[Remote DataSource / Dio]
        REPO_IMPL -->|Reads / Writes| LOCAL_DS[Secure Storage / Cache]
        REMOTE_DS -->|Serializes| MODEL[DTO Models]
        MODEL -->|toEntity| ENTITY
    end

    subgraph Common & Core
        ERR[Failures & Exceptions]
        NET[Dio Factory & Interceptors]
        THEME[Material 3 AppTheme & Colors]
        ROUTER[AutoRoute AppRouter]
        DI[GetIt & Injectable Graph]
    end

    REPO_IMPL -.-> ERR
    REMOTE_DS -.-> NET
    UI -.-> THEME
    UI -.-> ROUTER
    Presentation Layer -.-> DI
```

### Layer Boundaries

1. **`lib/domain/` (Pure Dart Core)**:
   - Contains Enterprise Business Rules and Application Business Rules.
   - Zero dependencies on Flutter UI (`flutter/*`) or external transport libraries (`dio`, `sqflite`, etc.).
   - Contains:
     - **Entities**: Immutable data structures representing core concepts (`PostItem`, `PostStatus`).
     - **Repository Contracts**: Abstract interfaces defining data boundaries returning `Either<Failure, T>` (`PostRepository`).
     - **Use Cases**: Single-responsibility business actions (`GetPostsUseCase`, `CreatePostUseCase`, `DeletePostUseCase`).

2. **`lib/data/` (Data Access & Infrastructure)**:
   - Implements domain repository interfaces and orchestrates remote/local data sources.
   - Contains:
     - **Models (DTOs)**: JSON serializable models with `fromJson`, `toJson`, and domain mapping methods (`toEntity()`).
     - **Data Sources**: Low-level client communications (`PostRemoteDataSource`, Dio REST integrations).
     - **Repositories**: Concrete implementations mapping typed data exceptions to domain failures (`PostRepositoryImpl`).

3. **`lib/presentation/` (User Interface & State Flow)**:
   - Reactive UI driven strictly by BLoC events and states.
   - Contains:
     - **BLoCs**: State containers consuming UseCases (`ThemeBloc`, `PostBloc`).
     - **Screens**: Routable pages annotated with `@RoutePage()` (`HomeScreen`).
     - **Widgets**: Reusable presentational components (`PostItemCard`, `CreatePostBottomSheet`).

4. **`lib/common/` (Shared Infrastructure)**:
   - **`network/`**: `DioClientFactory` (with default 15s connect/receive timeouts) and `ErrorHandlingInterceptor` translating HTTP errors into typed `NetworkException` hierarchies.
   - **`errors/`**: Domain `Failure` definitions (`ServerFailure`, `NetworkFailure`, `CacheFailure`) and Data `NetworkException` sealed classes.
   - **`storage/`**: `ISecureStorageService` wrapper around `flutter_secure_storage` with hardware-backed encryption.
   - **`theme/`**: Material 3 light/dark palette definitions (`AppColors`, `AppTextStyles`, `AppTheme`).
   - **`router/`**: Declarative routing with `auto_route` (`AppRouter`).

5. **`lib/di/` (Dependency Injection)**:
   - Compile-time dependency graph generation powered by `get_it` and `injectable`.
   - All modules, repositories, use cases, and blocs are registered with zero manual boilerplate.

---

## 🚀 Tech Stack & Core Libraries

| Category | Package | Version | Purpose |
| :--- | :--- | :--- | :--- |
| **State Management** | [`flutter_bloc`](https://pub.dev/packages/flutter_bloc) | `^9.1.1` | Predictable event-driven state container |
| **Value Equality** | [`equatable`](https://pub.dev/packages/equatable) | `^2.1.0` | Value-based equality comparisons without boilerplate |
| **Routing** | [`auto_route`](https://pub.dev/packages/auto_route) | `^11.1.0` | Strongly-typed, declarative navigation system |
| **Service Locator** | [`get_it`](https://pub.dev/packages/get_it) | `^9.2.1` | Fast, decoupled dependency locator |
| **DI Generator** | [`injectable`](https://pub.dev/packages/injectable) | `^2.5.0` | Compile-time code generator for `get_it` |
| **HTTP Client** | [`dio`](https://pub.dev/packages/dio) | `^5.11.0` | Powerful HTTP client with interceptors and timeouts |
| **Functional Error Handling**| [`dartz`](https://pub.dev/packages/dartz) | `^0.10.1` | Functional programming abstractions (`Either<Failure, T>`) |
| **Secure Storage** | [`flutter_secure_storage`](https://pub.dev/packages/flutter_secure_storage) | `^10.3.1` | Hardware-backed KeyStore/Keychain encrypted storage |
| **Internationalization** | [`intl`](https://pub.dev/packages/intl) | `^0.20.2` | Date formatting and localization support |
| **Testing** | [`mocktail`](https://pub.dev/packages/mocktail), [`bloc_test`](https://pub.dev/packages/bloc_test) | `^1.0.4` | Null-safe mocking and declarative BLoC testing |

---

## ✨ Features Implemented

### 1. Functional Dark & Light Theme Switcher
- Instant toggle button located in the top AppBar.
- Persists theme preferences to encrypted hardware storage via `ThemeBloc` and `ISecureStorageService`.
- Supports Light, Dark, and System modes with cohesive Material 3 color palettes.

### 2. Generic Post/Item Feed with Real-time Statuses
- Realistic entity model with unique ID, title, description, status badge (`Active`, `Pending`, `Completed`), and creation timestamp.
- Beautiful card layout with status color accents and relative date formatting.

### 3. Interactive Gestures: Left-Swipe-to-Delete
- Items wrapped with `Dismissible` supporting `DismissDirection.endToStart` (swipe left).
- Red background indicator with delete icon and confirmation label.
- **Optimistic UI Updates**: State updates instantly for silky-smooth animations, with automatic rollback and SnackBar error alerts if the delete operation fails.

### 4. Dynamic Item Creation via Modal Bottom Sheet
- Ergonomic Floating Action Button (FAB) at the bottom right.
- Material 3 modal bottom sheet with input validation, title, description, and interactive status selector chips (`ChoiceChip`).
- **SafeArea & ViewInsets Polish**: Form contents wrapped in `SafeArea(top: false)` and `SingleChildScrollView` with `MediaQuery.viewInsetsOf(context).bottom` padding to elevate cleanly above the iOS Home Indicator bar and eliminate keyboard pixel overflows.

### 5. SafeArea & Edge-to-Edge Protection
- Base screens (`HomeScreen`) wrap `Scaffold.body` in `SafeArea(top: false)` ensuring feed items, loading indicators, and empty placeholders are never obscured by bottom system navigation gesture bars or display cutouts.

### 6. Functional Error Handling
- Never throw unhandled exceptions across architectural boundaries!
- Data sources produce typed `NetworkException`s.
- Repositories catch exceptions and return `Either<Failure, T>`.
- Presentation layer cleanly folds the `Either` result into user-facing state transitions.

---

## 📂 Project Directory Structure

```text
lib/
├── app.dart                                # Root application widget with MaterialApp.router & ThemeBloc
├── main.dart                               # App entry point (initializes DI, Theme, & Flutter bindings)
├── common/
│   ├── errors/
│   │   ├── exceptions.dart                 # Data-layer NetworkException sealed hierarchy
│   │   └── failures.dart                   # Domain-layer Failure base & sub-classes
│   ├── network/
│   │   ├── dio_client_factory.dart         # Factory creating preconfigured Dio instances
│   │   └── error_handling_interceptor.dart # Interceptor converting DioException to NetworkException
│   ├── router/
│   │   ├── app_router.dart                 # AutoRoute configuration
│   │   └── app_router.gr.dart              # Generated route definitions
│   ├── storage/
│   │   └── secure_storage_service.dart     # Hardware-backed secure storage abstraction & implementation
│   └── theme/
│       ├── app_colors.dart                 # Color palette definitions
│       ├── app_text_styles.dart            # Typography hierarchy
│       └── app_theme.dart                  # Light and Dark ThemeData builders
├── data/
│   ├── datasources/
│   │   └── remote/
│   │       └── post_remote_datasource.dart # Remote REST data source contract & mock implementation
│   ├── models/
│   │   └── post_model.dart                 # JSON serializable DTO with toEntity() mapper
│   └── repositories/
│       └── post_repository_impl.dart      # PostRepository implementation returning Either<Failure, T>
├── di/
│   ├── injection.dart                      # GetIt service locator setup (@InjectableInit)
│   ├── injection.config.dart               # Generated DI registrations
│   └── modules/
│       └── register_module.dart            # External third-party registrations (Dio, SecureStorage)
├── domain/
│   ├── entities/
│   │   └── post_item.dart                  # PostItem immutable domain entity & PostStatus enum
│   ├── repositories/
│   │   └── post_repository.dart           # Pure Dart repository contract
│   └── usecases/
│       ├── create_post_usecase.dart        # Single-responsibility create use case
│       ├── delete_post_usecase.dart        # Single-responsibility delete use case
│       └── get_posts_usecase.dart          # Single-responsibility query use case
└── presentation/
    ├── modules/
    │   └── home/
    │       ├── bloc/
    │       │   ├── post_bloc.dart          # PostBloc handling Load, Add, and Remove events
    │       │   ├── post_event.dart         # Equatable PostEvent hierarchy
    │       │   └── post_state.dart         # Equatable PostState hierarchy
    │       ├── screens/
    │       │   └── home_screen.dart        # Routable HomeScreen with AppBar, ListView, FAB
    │       └── widgets/
    │           ├── create_post_bottom_sheet.dart # Modal bottom sheet with form inputs
    │           └── post_item_card.dart     # Material 3 item card with status chip
    └── theme/
        ├── theme_bloc.dart                 # ThemeBloc managing ThemeMode
        ├── theme_event.dart                # LoadInitialTheme, ToggleTheme, SetThemeMode
        └── theme_state.dart                # ThemeState with ThemeMode
```

---

## 🛠️ Getting Started

### Prerequisites
- **Flutter SDK**: `>= 3.29.0`
- **Dart SDK**: `>= 3.7.0`
- **Platform Tooling**: Xcode (for iOS) and Android Studio / Android SDK (for Android).

### Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone https://github.com/anantyan/flutter_boilerplate.git
   cd flutter_boilerplate
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run code generation**:
   Generate AutoRoute routes and Injectable dependency injection bindings:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Launch the application**:
   ```bash
   # Run on connected device / simulator
   flutter run
   ```

---

## 🧪 Testing

The project is backed by comprehensive unit and widget tests across all layers (45/45 tests passing with zero warnings):

```bash
# Run all automated tests
flutter test

# Run static analysis
dart analyze

# Check code formatting
dart format --set-exit-if-changed .
```

### Test Coverage Highlights
- **Failures & Exceptions**: Equality checks and message contracts.
- **Interceptors & Storage**: Network error status mapping and KeyStore/Keychain operations.
- **Repository Implementations**: Success conversions and exception-to-failure translation.
- **Use Cases**: Isolated business logic execution with Mocktail.
- **BLoCs**: `blocTest` asserting full event-to-state pipelines for `ThemeBloc` and `PostBloc`.
- **UI & Widgets**: Widget tests asserting loading spinners, empty states, error retry clicks, theme toggling, FAB opening bottom sheets, and drag gestures triggering swipe-to-delete.

---

## 📖 Developer Guide: Adding a New Feature

Follow this standard checklist to add a new feature (e.g., `Profile` or `Product`):

### 1. Domain Layer (`lib/domain/`)
1. Create the entity in `lib/domain/entities/<feature>.dart`.
2. Define the repository contract in `lib/domain/repositories/<feature>_repository.dart` returning `Future<Either<Failure, T>>`.
3. Create use cases in `lib/domain/usecases/` annotated with `@injectable`.

### 2. Data Layer (`lib/data/`)
1. Create the DTO model in `lib/data/models/<feature>_model.dart` with `fromJson`, `toJson`, and `toEntity()`.
2. Define the data source in `lib/data/datasources/remote/<feature>_remote_datasource.dart` annotated with `@lazySingleton`.
3. Implement the repository in `lib/data/repositories/<feature>_repository_impl.dart` annotated with `@LazySingleton(as: <Feature>Repository)`.

### 3. Presentation Layer (`lib/presentation/`)
1. Create the BLoC in `lib/presentation/modules/<feature>/bloc/` with `Event`, `State`, and `Bloc` annotated with `@injectable`.
2. Create the UI widgets in `lib/presentation/modules/<feature>/widgets/`.
3. Create the routable screen in `lib/presentation/modules/<feature>/screens/<feature>_screen.dart` annotated with `@RoutePage()`.

### 4. Routing & DI Generation
1. Add the route to `lib/common/router/app_router.dart`:
   ```dart
   AutoRoute(page: FeatureRoute.page, path: '/feature'),
   ```
2. Re-run the code generator:
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```
3. Add unit and widget tests in `test/`.

---

## 📄 License
This project is open source and available under the [MIT License](LICENSE).
