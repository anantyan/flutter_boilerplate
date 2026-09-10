# Phased Modification Implementation Plan: SafeArea Integration

* **Target Directory:** `/Volumes/E350/anantyan/documents/FlutterProjects/flutter_boilerplate`
* **Target Feature Branch:** `feature/safe-area-refinement`
* **Status:** Pending User Approval

---

## Developer Notice & Rule
> **IMPORTANT:** After completing any task, if you added any `TODO`s to the code or didn't fully implement anything, make sure to add new tasks so that you can come back and complete them later. No task should be left half-done or untracked.

---

## Journal & Progress Log

*This section will be updated chronologically after each phase to log actions taken, learnings, surprises, and any deviations from the plan.*

* **Phase 1 Initiation:** Initialized feature branch `feature/safe-area-refinement`. Baseline test verification passed (43/43 tests).
* **Phase 1 Completed:** Implemented `SafeArea(top: false)` and `SingleChildScrollView` inside `CreatePostBottomSheet`. Added widget test asserting both widgets exist in tree. Code clean with `dart analyze` (0 issues), all 44 tests passed, and formatted with `dart format`.
* **Phase 2 Completed:** Wrapped `Scaffold.body` in `SafeArea(top: false)` in `HomeScreen`. Updated widget test asserting body `SafeArea` predicate. Verified with `dart analyze` (0 issues), all 45 tests passing, and formatted with `dart format`.

---

## Phase 1: Baseline Verification & CreatePostBottomSheet SafeArea Integration

- [x] Run all tests to ensure the project is in a good state before starting modifications.
- [x] Refactor `lib/presentation/modules/home/widgets/create_post_bottom_sheet.dart`:
  - Wrap modal form inside `SafeArea(top: false)` within the styled `Container`.
  - Wrap the inner column with `SingleChildScrollView` to prevent keyboard / small display pixel overflows.
  - Retain `MediaQuery.viewInsetsOf(context).bottom` for smooth software keyboard elevation.
- [x] Create/modify unit & widget tests in `test/presentation/modules/home/widgets/create_post_bottom_sheet_test.dart` to verify `SafeArea` and scroll view composition.
- [x] Run `dart fix --apply` to clean up code.
- [x] Run `dart analyze` and fix any issues.
- [x] Run `flutter test` to ensure all tests pass.
- [x] Run `dart format .` to ensure correct formatting.
- [x] Re-read `MODIFICATION_IMPLEMENTATION.md` to see what, if anything, has changed in the plan.
- [x] Update `MODIFICATION_IMPLEMENTATION.md` Journal with actions taken and check off completed items.
- [x] Use `git diff` to verify changes, prepare commit message, and present to user for approval.
- [x] Wait for approval. Commit changes after approval.
- [x] Perform hot reload on running app via Marionette or Flutter CLI.

---

## Phase 2: HomeScreen Body SafeArea Integration

- [x] Refactor `lib/presentation/modules/home/screens/home_screen.dart`:
  - Wrap `HomeView`'s `Scaffold.body` (`BlocConsumer<PostBloc, PostState>`) in `SafeArea(top: false)`.
  - Ensure centered states (`PostLoading`, `PostFailure`, empty state) and `ListView.builder` are properly inset from the device bottom gesture bar and side bezels.
- [x] Create/modify widget tests in `test/presentation/modules/home/home_screen_test.dart` to verify `SafeArea` widget presence in the tree.
- [x] Run `dart fix --apply`.
- [x] Run `dart analyze` and ensure 0 issues.
- [x] Run `flutter test` to ensure all tests pass.
- [x] Run `dart format .`.
- [x] Re-read `MODIFICATION_IMPLEMENTATION.md` and update Journal with state and findings.
- [x] Use `git diff` to verify changes, prepare commit message, and present to user for approval.
- [ ] Wait for approval. Commit changes after approval.
- [ ] Perform hot reload on running app.

---

## Phase 3: Marionette Live E2E Verification & Screenshot Validation

- [ ] Connect Marionette MCP to the running simulator app.
- [ ] Query live interactive elements using `get_interactive_elements`.
- [ ] Capture screenshot of `HomeScreen` to verify `SafeArea` layout on iPhone 17 Pro.
- [ ] Trigger `add_post_fab` to open `CreatePostBottomSheet` modal.
- [ ] Capture screenshot of open bottom sheet to confirm bottom `SafeArea` elevation above Home Indicator.
- [ ] Interact with form inputs and submit a test post to verify zero regressions.
- [ ] Dismiss or swipe item to verify gesture behavior with new safe areas.
- [ ] Run `dart analyze` and `flutter test`.
- [ ] Update `MODIFICATION_IMPLEMENTATION.md` Journal with screenshot results and E2E verification status.
- [ ] Prepare commit message for Phase 3, present to user, and commit after approval.

---

## Phase 4: Documentation, Pull Request, Merge to Develop & Main

- [ ] Update `README.md` to document the `SafeArea` responsive design patterns.
- [ ] Update `GEMINI.md` to note `SafeArea` guidelines for UI sheets and screens.
- [ ] Update `CHANGELOG.md` with refinement release notes.
- [ ] Run full project compilation check: `flutter test` and `dart analyze`.
- [ ] Update `MODIFICATION_IMPLEMENTATION.md` Journal with final summary.
- [ ] Push `feature/safe-area-refinement` to GitHub remote.
- [ ] Merge `feature/safe-area-refinement` into `develop`.
- [ ] Fast-forward / merge `develop` into `main` after user clinical verification.
- [ ] Ask user to inspect the package and running app, and confirm satisfaction.
