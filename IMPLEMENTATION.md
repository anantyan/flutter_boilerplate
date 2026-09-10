# Phased Implementation Plan: `flutter_boilerplate`

* **Target Directory:** `/Volumes/E350/anantyan/documents/FlutterProjects/flutter_boilerplate`
* **Package Name:** `flutter_boilerplate`
* **Organization:** `dev.flutter.boilerplate.anantyan`
* **Platforms:** Android, iOS
* **Git Branch:** `develop` (tracking `main`)
* **Status:** Pending User Approval

---

## Developer Notice & Rule
> **IMPORTANT:** After completing any task, if you added any `TODO`s to the code or didn't fully implement anything, make sure to add new tasks so that you can come back and complete them later. No task should be left half-done or untracked.

---

## Journal & Progress Log

*This section will be updated chronologically after each phase to log actions taken, learnings, surprises, and any deviations from the plan.*

* **Phase 1 Initiation:** Initializing project structure on branch `develop`, targeting Android & iOS.
* **Phase 1 Completed:** Generated Flutter app package targeting Android & iOS with application ID `dev.flutter.boilerplate.anantyan`. Configured `pubspec.yaml` version to 0.1.0, created `README.md` and `CHANGELOG.md`. Code formatted with `dart format` and verified with `dart analyze` (0 warnings).
* **Phase 2 Completed:** Added dependencies (`flutter_bloc`, `equatable`, `auto_route`, `get_it`, `injectable`, `dio`, `dartz`, `flutter_secure_storage`, `intl`, `mocktail`, `bloc_test`). Configured `AppColors`, `AppTextStyles`, `AppTheme` (Light & Dark), `ISecureStorageService` wrapper, and `ThemeBloc` with persistent storage. Verified with 8 passing unit tests, `dart format`, and clean `dart analyze` (0 issues).
* **Phase 3 Completed:** Implemented domain failure abstractions (`Failure`, `ServerFailure`, `NetworkFailure`, etc.), sealed data exceptions (`NetworkException`), `ErrorHandlingInterceptor`, `DioClientFactory` (15s timeouts, auto-logging), and `get_it` + `injectable` service locator with generated `injection.config.dart`. Added 8 new unit tests (16/16 tests passing total).
* **Phase 4 Completed:** Implemented Domain Layer (`PostItem` entity, `PostRepository` contract with `dartz` `Either<Failure, T>`, and use cases `GetPostsUseCase`, `CreatePostUseCase`, `DeletePostUseCase`). Implemented Data Layer (`PostModel` DTO, `PostRemoteDataSource` with seeded mock REST simulation, and `PostRepositoryImpl`). Generated DI wiring and added 8 unit tests (24/24 unit tests passing total).
* **Phase 5 Completed:** Implemented Presentation Layer including `PostBloc` (with optimistic delete & failure rollback), `AutoRoute` configuration (`AppRouter` with `HomeRoute`), UI widgets (`PostItemCard`, `CreatePostBottomSheet`), and `HomeScreen` (AppBar dark/light theme switcher, pull-to-refresh, `Dismissible` swipe-left-to-delete, and FAB). Connected root `App` with `ThemeBloc` and `MaterialApp.router`. Added 19 new unit and widget tests across bloc, screens, and widgets (43/43 tests passing total), formatted with `dart format`, and verified with `dart analyze` (0 issues).
* **Phase 6 Completed:** Verified full test suite (43/43 tests passing) and static analysis (0 analyzer issues). Authored comprehensive documentation including `README.md` (with architecture diagram, developer guide, and command cheatsheet), `GEMINI.md` (specifying architectural invariants, error handling rules, and AI assistant instructions), and updated `CHANGELOG.md` with complete 0.1.0 release notes. All phases completed successfully.

---

## Phase 1: Project Scaffolding & Initial Empty Package

- [x] Create a Flutter package in the package directory (`.`) targeting Android and iOS with org `dev.flutter.boilerplate.anantyan`.
- [x] Remove any boilerplate in the new package that will be replaced, including the default sample counter test directory.
- [x] Update the description of the package in `pubspec.yaml` and set the initial version number to `0.1.0`.
- [x] Update `README.md` to include a short placeholder description of the boilerplate package.
- [x] Create `CHANGELOG.md` with the initial release version of `0.1.0`.
- [x] Run `dart format .` and `dart analyze` to ensure clean baseline.
- [x] Re-read `IMPLEMENTATION.md` and update the Journal with Phase 1 completion details.
- [x] Stage and commit this empty baseline version of the package to the `develop` branch.
- [x] Present commit message to the user for approval.

---

## Phase 2: Core Dependencies, Theming & Secure Storage

- [x] Add runtime and dev dependencies to `pubspec.yaml`:
  - Runtime: `flutter_bloc: ^9.1.1`, `equatable: ^2.1.0`, `auto_route: ^11.1.0`, `get_it: ^9.2.1`, `injectable: ^2.5.0`, `dio: ^5.11.0`, `dartz: ^0.10.1`, `flutter_secure_storage: ^10.3.1`, `intl: ^0.20.2`.
  - Dev: `build_runner: ^2.4.15`, `injectable_generator: ^2.7.0`, `auto_route_generator: ^10.5.0`, `flutter_lints: ^6.0.0`.
- [x] Configure `lib/common/theme/`:
  - `app_colors.dart`: Standard Light & Dark palette definitions.
  - `app_text_styles.dart`: Standard typography scale.
  - `app_theme.dart`: `ThemeData` builders for Light & Dark mode.
- [x] Configure `lib/common/storage/secure_storage_service.dart`:
  - Hardware-backed secure storage wrapper for Android & iOS.
- [x] Implement Theme BLoC in `lib/presentation/theme/`:
  - `theme_event.dart`: LoadInitialTheme, ToggleTheme.
  - `theme_state.dart`: ThemeState carrying `ThemeMode`.
  - `theme_bloc.dart`: Event handling with storage persistence.
- [x] Create unit tests for `ThemeBloc` and `SecureStorageService`.
- [x] Run `dart fix --apply` and `dart analyze`.
- [x] Run `flutter test` to ensure all tests pass.
- [x] Run `dart format .`.
- [x] Update `IMPLEMENTATION.md` Journal section.
- [x] Present commit message to user for approval, then commit to `develop`.

---

## Phase 3: Network Infrastructure & Functional Error Handling

- [x] Create domain failures in `lib/common/errors/failures.dart`:
  - `Failure` base class, `ServerFailure`, `NetworkFailure`, `CacheFailure`, `ValidationFailure`.
- [x] Create data layer exceptions in `lib/common/errors/exceptions.dart`:
  - `NetworkException` sealed hierarchy mapping HTTP status codes (BadRequest, Unauthorized, Forbidden, NotFound, ServerError, NoInternet).
- [x] Implement `lib/common/network/`:
  - `dio_client_factory.dart`: Factory configuring base options, timeouts (15s), and headers.
  - `error_handling_interceptor.dart`: Interceptor translating `DioException` to typed `NetworkException`.
- [x] Configure Dependency Injection setup in `lib/di/`:
  - `injection.dart`: Service locator entry point with `@InjectableInit`.
  - `modules/register_module.dart`: Injectable module registering external third-party instances (`Dio`, `FlutterSecureStorage`).
- [x] Create unit tests for `ErrorHandlingInterceptor` and network mapping.
- [x] Run `dart fix --apply`, `dart analyze`, and `flutter test`.
- [x] Run `dart format .`.
- [x] Update `IMPLEMENTATION.md` Journal section.
- [x] Present commit message to user for approval, then commit to `develop`.

---

## Phase 4: Domain & Data Layers (Generic Post/Item Module)

- [x] Implement Domain Layer for Post entity:
  - `lib/domain/entities/post_item.dart`: `PostItem` entity with id, title, body, status, and createdAt timestamp.
  - `lib/domain/repositories/post_repository.dart`: Abstract repository contract returning `Future<Either<Failure, List<PostItem>>>`, `Future<Either<Failure, PostItem>>`, `Future<Either<Failure, Unit>>`.
  - `lib/domain/usecases/`:
    - `get_posts_usecase.dart`
    - `create_post_usecase.dart`
    - `delete_post_usecase.dart`
- [x] Implement Data Layer:
  - `lib/data/models/post_model.dart`: DTO with `toJson` and `fromJson`, and `toEntity()` mapping.
  - `lib/data/datasources/remote/post_remote_datasource.dart`: Remote data source contract and implementation with simulated/mock REST endpoints.
  - `lib/data/repositories/post_repository_impl.dart`: Repository implementation with try/catch mapping `NetworkException` to `ServerFailure`.
- [x] Unit tests for `PostRepositoryImpl` and use cases using mocks.
- [x] Run `dart fix --apply`, `dart analyze`, and `flutter test`.
- [x] Run `dart format .`.
- [x] Update `IMPLEMENTATION.md` Journal section.
- [x] Present commit message to user for approval, then commit to `develop`.

---

## Phase 5: Presentation Layer, AutoRoute & Interactive Gestures

- [x] Implement `PostBloc` in `lib/presentation/modules/home/bloc/`:
  - `post_event.dart`: LoadPosts, AddPost, RemovePost.
  - `post_state.dart`: Initial, Loading, Loaded(List<PostItem>), Failure(String message).
  - `post_bloc.dart`: Event handling calling use cases and emitting updated states with optimistic swipe-to-delete.
- [x] Configure Declarative Navigation in `lib/common/router/app_router.dart`:
  - Setup `@AutoRouterConfig()` with `HomeScreen`.
- [x] Build UI Screens & Widgets in `lib/presentation/modules/home/`:
  - `widgets/post_item_card.dart`: Clean Material 3 card with status chip and formatted date.
  - `widgets/create_post_bottom_sheet.dart`: Ergonomic bottom sheet form for creating posts.
  - `screens/home_screen.dart`:
    - Top AppBar with functional Dark/Light theme switcher button.
    - ListView with `Dismissible` (swipe left to delete with background indicator & SnackBar notification).
    - Floating Action Button (FAB) triggering `CreatePostBottomSheet`.
    - Pull-to-refresh (`RefreshIndicator`).
- [x] Wire root application in `lib/app.dart` and `lib/main.dart`:
  - Wrap MaterialApp with `BlocProvider<ThemeBloc>` using `routerConfig: appRouter.config()`.
- [x] Run code generator: `dart run build_runner build --delete-conflicting-outputs`.
- [x] Write widget tests for `HomeScreen`, `PostBloc`, `CreatePostBottomSheet`, `PostItemCard`, and `App`.
- [x] Run `dart fix --apply`, `dart analyze`, and `flutter test`.
- [x] Run `dart format .`.
- [x] Update `IMPLEMENTATION.md` Journal section.
- [x] Present commit message to user for approval, then commit to `develop`.

---

## Phase 6: Verification, Complete Documentation & Delivery

- [x] Run full project compilation check: `flutter test` and `dart analyze`.
- [x] Create comprehensive `README.md` detailing architecture, layer boundaries, how to add a new feature, and how to run tests.
- [x] Create `GEMINI.md` describing project layout, architectural rules, and guidelines for AI assistant pairing.
- [x] Update `CHANGELOG.md` with the full 0.1.0 release notes.
- [x] Update `IMPLEMENTATION.md` Journal with final summary.
- [x] Review `git diff`, present final commit message to user for approval, and commit to `develop`.
- [ ] Ask user to inspect the project and confirm satisfaction.

