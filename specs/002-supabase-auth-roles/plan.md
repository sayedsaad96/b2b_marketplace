# Implementation Plan: Supabase Authentication & Role-Based Routing

**Branch**: `002-supabase-auth-roles` | **Date**: 2026-02-26 | **Spec**: [spec.md](file:///d:/Sayed/Flutter/b2b_marketplace/specs/002-supabase-auth-roles/spec.md)  
**Input**: Feature specification from `/specs/002-supabase-auth-roles/spec.md`

## Summary

This plan implements Phase 2 of the B2B Marketplace app: Supabase email/password authentication with role-based routing. Users select a role (Brand/Factory) during sign-up, and after authentication (sign-up or login) they are routed to the appropriate placeholder home screen based on their profile role. The implementation follows the existing Clean Architecture pattern with `flutter_bloc` (Cubit), `go_router`, and `get_it`.

## Technical Context

**Language/Version**: Dart ^3.10.7 / Flutter (latest stable)  
**Primary Dependencies**: `supabase_flutter` ^2.9.0, `flutter_bloc` ^9.1.0, `go_router` ^15.1.2, `get_it` ^8.0.3, `equatable` ^2.0.7, `easy_localization` ^3.0.7+1, `flutter_screenutil` ^5.9.3  
**Storage**: Supabase PostgreSQL (`profiles` table — assumed pre-existing)  
**Testing**: `flutter_test`  
**Target Platform**: Android (min SDK 21) + iOS (min iOS 13)  
**Project Type**: Mobile app (Flutter cross-platform)  
**Performance Goals**: Login/sign-up response < 5 seconds on standard network  
**Constraints**: Clean Architecture strict, no Firebase, zero analyzer warnings  
**Scale/Scope**: 3 user roles, ~5 new screens, ~15 new files

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Gate | Status | Notes |
|------|--------|-------|
| Clean Architecture (data/domain/presentation) | ✅ Pass | All auth code follows the 3-layer split |
| Dependency rule (presentation → domain ← data) | ✅ Pass | Domain has zero external deps |
| `supabase_flutter` for backend (no Firebase) | ✅ Pass | Supabase only |
| `flutter_bloc` for state management | ✅ Pass | Auth Cubit with sealed states |
| `go_router` for navigation | ✅ Pass | Routes added to existing AppRouter |
| `get_it` for DI | ✅ Pass | All new deps registered in injection_container.dart |
| `easy_localization` — no hardcoded strings | ✅ Pass | All user-facing strings use `.tr()` |
| `flutter_screenutil` — responsive sizing | ✅ Pass | All new screens use `.w`, `.h`, `.sp` |
| `dartz`/`fpdart` for error handling | ⚠️ Action | Need to add `dartz` to pubspec.yaml (not yet present) |
| `equatable` for state equality | ✅ Pass | Already in dependencies |
| Null-safe, zero warnings | ✅ Pass | Enforced by analysis_options.yaml |
| No `print()` calls | ✅ Pass | Will use `log()` if needed |
| Environment variables via `.env` | ✅ Pass | Supabase URL + anon key stored in constants file (not committed) |

## Project Structure

### Documentation (this feature)

```text
specs/002-supabase-auth-roles/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
└── tasks.md             # Phase 2 output (created by /speckit.tasks)
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_routes.dart          # [MODIFY] Add auth + home route constants
│   │   └── supabase_constants.dart  # [NEW] Supabase URL + anon key
│   ├── error/
│   │   └── failures.dart            # [NEW] Typed Failure classes
│   ├── network/
│   │   └── supabase_client.dart     # [NEW] Supabase init helper (if needed)
│   └── router/
│       └── app_router.dart          # [MODIFY] Add auth + home routes + redirect
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── auth_remote_datasource.dart      # [NEW]
│   │   │   ├── models/
│   │   │   │   └── user_profile_model.dart           # [NEW]
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart         # [NEW]
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── user_profile.dart                 # [NEW]
│   │   │   ├── repositories/
│   │   │   │   └── auth_repository.dart              # [NEW] abstract
│   │   │   └── usecases/
│   │   │       ├── sign_up_usecase.dart              # [NEW]
│   │   │       ├── sign_in_usecase.dart              # [NEW]
│   │   │       ├── sign_out_usecase.dart             # [NEW]
│   │   │       └── get_current_profile_usecase.dart  # [NEW]
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_cubit.dart                   # [NEW]
│   │       │   └── auth_state.dart                   # [NEW]
│   │       ├── pages/
│   │       │   ├── login_page.dart                   # [NEW]
│   │       │   └── sign_up_page.dart                 # [NEW]
│   │       └── widgets/
│   │           └── auth_text_field.dart              # [NEW] reusable input
│   ├── brand/
│   │   └── presentation/
│   │       └── pages/
│   │           └── brand_home_page.dart              # [NEW] placeholder
│   ├── factory/
│   │   └── presentation/
│   │       └── pages/
│   │           └── factory_home_page.dart            # [NEW] placeholder
│   └── admin/
│       └── presentation/
│           └── pages/
│               └── admin_dashboard_page.dart         # [NEW] placeholder
│
├── injection_container.dart   # [MODIFY] Register auth dependencies
└── main.dart                  # [MODIFY] Init Supabase before runApp

assets/translations/
├── en.json                    # [MODIFY] Add auth.* translation keys
└── ar.json                    # [MODIFY] Add auth.* translation keys
```

**Structure Decision**: Flutter mobile app following Clean Architecture with feature-based modules. Auth is a new feature module. Placeholder home screens are separate feature modules (brand, factory, admin) to allow independent growth in future phases.

## Ordered Implementation Steps

> Each step is a small, independently testable unit of work.

---

### Step 1: Add `dartz` dependency and create Failure classes

**What**: Add `dartz` package to `pubspec.yaml` for functional error handling (`Either<Failure, T>`). Create `core/error/failures.dart` with a base `Failure` class and typed subclasses.

**Files**:
- `pubspec.yaml` — add `dartz: ^0.10.1`
- `lib/core/error/failures.dart` — `Failure` (abstract, extends `Equatable`), `ServerFailure`, `AuthFailure`, `CacheFailure`

**Depends on**: Nothing

---

### Step 2: Create Supabase constants and initialize Supabase in `main.dart`

**What**: Create a constants file for the Supabase URL and anon key. Add `Supabase.initialize()` in `main.dart` before `runApp()`.

**Files**:
- `lib/core/constants/supabase_constants.dart` — `SupabaseConstants.url`, `SupabaseConstants.anonKey`
- `lib/main.dart` — add `await Supabase.initialize(url:..., anonKey:...)` in `main()`

**Depends on**: Nothing

---

### Step 3: Create Auth domain layer (entity + repository contract + use cases)

**What**: Define the pure domain layer for authentication. No external dependencies.

**Files**:
- `lib/features/auth/domain/entities/user_profile.dart` — `UserProfile` entity (id, fullName, role, createdAt) extending `Equatable`
- `lib/features/auth/domain/repositories/auth_repository.dart` — abstract `AuthRepository` with `signUp()`, `signIn()`, `signOut()`, `getCurrentUserProfile()` returning `Future<Either<Failure, T>>`
- `lib/features/auth/domain/usecases/sign_up_usecase.dart` — `SignUpUseCase`
- `lib/features/auth/domain/usecases/sign_in_usecase.dart` — `SignInUseCase`
- `lib/features/auth/domain/usecases/sign_out_usecase.dart` — `SignOutUseCase`
- `lib/features/auth/domain/usecases/get_current_profile_usecase.dart` — `GetCurrentProfileUseCase`

**Depends on**: Step 1 (Failure classes)

---

### Step 4: Create Auth data layer (model + datasource + repository impl)

**What**: Implement the data layer that talks to Supabase.

**Files**:
- `lib/features/auth/data/models/user_profile_model.dart` — `UserProfileModel` extends `UserProfile`, adds `fromJson()` / `toJson()`
- `lib/features/auth/data/datasources/auth_remote_datasource.dart` — `AuthRemoteDataSource` (abstract) + `AuthRemoteDataSourceImpl` using `SupabaseClient`
- `lib/features/auth/data/repositories/auth_repository_impl.dart` — `AuthRepositoryImpl` implements `AuthRepository`, wraps datasource calls in try/catch returning `Either<Failure, T>`

**Depends on**: Step 2 (Supabase client available), Step 3 (domain contracts)

---

### Step 5: Create Auth Cubit and states

**What**: Implement the state management layer using `Cubit`.

**Files**:
- `lib/features/auth/presentation/bloc/auth_state.dart` — sealed class with `AuthInitial`, `AuthLoading`, `AuthAuthenticated(userProfile)`, `AuthError(message)`, `AuthUnauthenticated`
- `lib/features/auth/presentation/bloc/auth_cubit.dart` — `AuthCubit` extends `Cubit<AuthState>`, methods: `signUp()`, `signIn()`, `signOut()`, `checkAuthStatus()`

**Depends on**: Step 3 (use cases)

---

### Step 6: Register all auth dependencies in `injection_container.dart`

**What**: Wire up all new classes in the service locator (get_it).

**Files**:
- `lib/injection_container.dart` — register `AuthRemoteDataSource`, `AuthRepository`, use cases, `AuthCubit`

**Depends on**: Steps 3, 4, 5

---

### Step 7: Build Login and Sign Up screens

**What**: Create the two auth screens with form validation, error display, and localized strings.

**Files**:
- `lib/features/auth/presentation/widgets/auth_text_field.dart` — reusable styled text field
- `lib/features/auth/presentation/pages/login_page.dart` — email + password fields, login button, link to sign-up, error display via `BlocListener`
- `lib/features/auth/presentation/pages/sign_up_page.dart` — full name + email + password fields + role (passed from role selection), sign-up button, link to login, error display via `BlocListener`
- `assets/translations/en.json` — add `auth.login.*`, `auth.signup.*`, `auth.errors.*` keys
- `assets/translations/ar.json` — add corresponding Arabic translations

**Depends on**: Step 5 (Cubit), Step 6 (DI)

---

### Step 8: Create placeholder home screens (Brand, Factory, Admin)

**What**: Simple `Scaffold` screens with centered text showing the role name. Each includes a sign-out button/action.

**Files**:
- `lib/features/brand/presentation/pages/brand_home_page.dart` — `BrandHomePage` with "Brand Home" text + sign out
- `lib/features/factory/presentation/pages/factory_home_page.dart` — `FactoryHomePage` with "Factory Home" text + sign out
- `lib/features/admin/presentation/pages/admin_dashboard_page.dart` — `AdminDashboardPage` with "Admin Dashboard" text + sign out

**Depends on**: Step 5 (Cubit for sign-out)

---

### Step 9: Update GoRouter with auth routes, home routes, and redirect logic

**What**: Add all new routes and implement route guard logic (redirect unauthenticated users to login, redirect authenticated users to their role-based home).

**Files**:
- `lib/core/constants/app_routes.dart` — add `login`, `signUp`, `brandHome`, `factoryHome`, `adminDashboard` constants
- `lib/core/router/app_router.dart` — add `GoRoute` entries for all new paths, add `redirect` callback that checks auth state and role

**Depends on**: Steps 6, 7, 8

---

### Step 10: Connect Role Selection screen to auth flow

**What**: Update the existing `RoleSelectionPage`'s Continue button to navigate to the sign-up screen, passing the selected role as a route parameter or extra.

**Files**:
- `lib/features/role_selection/presentation/pages/role_selection_page.dart` — replace placeholder `SnackBar` with `context.go(AppRoutes.signUp, extra: selectedRole)`

**Depends on**: Step 9 (routes exist)

---

## Verification Plan

### Automated Tests

Tests will be placed under `test/features/auth/`.

1. **Unit tests — Auth Cubit** (`test/features/auth/presentation/bloc/auth_cubit_test.dart`):
   - Test `signUp()` emits `[AuthLoading, AuthAuthenticated]` on success
   - Test `signUp()` emits `[AuthLoading, AuthError]` on failure
   - Test `signIn()` emits `[AuthLoading, AuthAuthenticated]` on success
   - Test `signIn()` emits `[AuthLoading, AuthError]` on failure
   - Test `signOut()` emits `[AuthUnauthenticated]`
   - Test `checkAuthStatus()` emits correct state
   - Run: `flutter test test/features/auth/presentation/bloc/auth_cubit_test.dart`

2. **Unit tests — Auth Repository** (`test/features/auth/data/repositories/auth_repository_impl_test.dart`):
   - Test `signUp()` returns `Right(UserProfile)` on success
   - Test `signUp()` returns `Left(AuthFailure)` on exception
   - Test `signIn()` returns `Right(UserProfile)` on success
   - Test `getCurrentUserProfile()` returns profile when logged in
   - Run: `flutter test test/features/auth/data/repositories/auth_repository_impl_test.dart`

3. **Static analysis**:
   - Run: `flutter analyze` — expect zero warnings/errors

### Manual Verification

> These steps require a Supabase project with the `profiles` table configured.

1. **Sign-up flow**: Open app → complete onboarding → select Brand → tap Continue → fill in name/email/password → tap Sign Up → verify you land on "Brand Home" screen
2. **Login flow**: Open app → go to Login → enter existing credentials → verify correct home screen
3. **Role routing**: Login with a Factory account → verify you see "Factory Home"
4. **Error handling**: Try signing up with an already-registered email → verify error message appears
5. **Sign out**: From any home screen → tap Sign Out → verify you return to Login screen
6. **Session persistence**: Login → close app → reopen → verify you skip login and go directly to home screen
7. **Route guarding**: While logged out, try navigating to `/brand/home` → verify redirect to login
