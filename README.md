# flutter_boilerplate

A robust, scalable Clean Architecture Flutter boilerplate for Android and iOS.

## Features
- **Clean Architecture:** Strict separation between Presentation, Domain, Data, and Common/Core layers.
- **State Management:** BLoC (`flutter_bloc`) for predictable, testable state flows.
- **Dependency Injection:** Compile-time DI with `injectable` and `get_it`.
- **Declarative Navigation:** Strongly-typed route generator via `auto_route`.
- **Network & Error Handling:** `dio` with functional error handling via `dartz` (`Either<Failure, T>`) and typed `NetworkException`.
- **Encrypted Local Storage:** Hardware-backed storage via `flutter_secure_storage`.
- **Built-in Sample Modules:**
  - Dynamic Dark/Light mode theme switcher.
  - Interactive Post/Item entity feed with swipe-to-delete and FAB bottom sheet.

## Getting Started
See [DESIGN.md](DESIGN.md) for architectural guidelines and [IMPLEMENTATION.md](IMPLEMENTATION.md) for current implementation progress.
