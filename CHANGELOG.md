# Changelog

All notable changes to this project will be documented in this file.

## [0.1.0] - 2026-09-10

### Added
- **Core Scaffolding**: Initial project scaffolding for `flutter_boilerplate` targeting Android & iOS (`dev.flutter.boilerplate.anantyan`).
- **Architecture Documentation**: Comprehensive technical specification (`DESIGN.md`), implementation log (`IMPLEMENTATION.md`), AI assistant pairing guide (`GEMINI.md`), and developer manual (`README.md`).
- **Core Theming**: Material 3 Light and Dark palettes (`AppColors`, `AppTextStyles`, `AppTheme`) with persistent theme state management via `ThemeBloc`.
- **Encrypted Local Storage**: Hardware-backed KeyStore/Keychain storage service wrapper (`ISecureStorageService` and `SecureStorageService`).
- **Network Infrastructure**: Preconfigured `DioClientFactory` (15s timeouts, headers) and `ErrorHandlingInterceptor` translating HTTP errors into typed `NetworkException` hierarchies.
- **Functional Error Handling**: Domain `Failure` sealed hierarchy and `dartz` `Either<Failure, T>` return types across repository boundaries.
- **Compile-Time Dependency Injection**: `GetIt` and `injectable` service locator with auto-generated registration graph (`lib/di/`).
- **Domain Layer for Posts**: Pure Dart domain entity `PostItem`, `PostStatus` enum, `PostRepository` contract, and use cases `GetPostsUseCase`, `CreatePostUseCase`, and `DeletePostUseCase`.
- **Data Layer for Posts**: Serializable DTO `PostModel`, simulated remote REST datasource `PostRemoteDataSource`, and robust repository implementation `PostRepositoryImpl`.
- **Presentation Layer & UI**:
  - `PostBloc` managing post states with optimistic swipe-to-delete and notification messages.
  - Material 3 `HomeScreen` with top AppBar theme toggle button, `RefreshIndicator` pull-to-refresh, and Floating Action Button.
  - `PostItemCard` widget with dynamic status chips (`Active`, `Pending`, `Completed`) and formatted timestamps.
  - `CreatePostBottomSheet` modal form for adding items with input validation.
  - `Dismissible` swipe-left-to-delete gesture with red background indicators and SnackBar confirmations.
- **Declarative Navigation**: Strongly-typed `AutoRoute` configuration with `AppRouter` and generated `HomeRoute`.
- **Application Root**: Wired `lib/app.dart` and `lib/main.dart` with `ThemeBloc`, `MaterialApp.router`, and startup theme preloading.
- **Testing**: 43 automated unit and widget tests covering failures, network interceptors, secure storage, repository implementations, use cases, BLoCs, widgets, and root application.
