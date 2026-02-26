# B2B Marketplace — Project Constitution

> This document defines the **non-negotiable** foundational principles, architecture, and coding standards for the B2B Fashion Manufacturing Marketplace (Egypt). All specs, plans, and tasks **must** adhere to these guidelines.

---

## 1. Project Overview

| Field         | Value                                                        |
|---------------|--------------------------------------------------------------|
| **Name**      | B2B Marketplace                                              |
| **Domain**    | Fashion manufacturing marketplace for Egypt                  |
| **Type**      | Flutter cross-platform application                           |
| **SDK**       | Dart ^3.10.7 / Flutter (latest stable)                       |
| **Roles**     | **Brand**, **Factory**, **Admin** (Admin web dashboard is a later phase) |

---

## 2. Tech Stack

| Layer                  | Choice                                       |
|------------------------|----------------------------------------------|
| **Framework**          | Flutter                                      |
| **Language**           | Dart (null-safe, zero analyzer warnings)     |
| **State Management**   | `flutter_bloc` (Cubit + Bloc)                |
| **Navigation**         | `go_router`                                  |
| **Dependency Injection** | `get_it` + `injectable` (optional)         |
| **Backend**            | `supabase_flutter` (Auth, PostgreSQL, Storage) |
| **Localization**       | `easy_localization` (AR + EN, full RTL)      |
| **Responsive UI**      | `flutter_screenutil`                         |
| **HTTP (if needed)**   | `dio` or Supabase client                     |

> [!CAUTION]
> **Firebase is strictly prohibited.** All backend services must use Supabase.

---

## 3. Architecture — Clean Architecture (Strict)

```
lib/
├── core/                         # Shared across all features
│   ├── constants/                # App-wide constants
│   ├── error/                    # Failure & Exception classes
│   ├── network/                  # Network info, Supabase client setup
│   ├── theme/                    # AppTheme, colors, text styles
│   ├── usecase/                  # Base UseCase abstract class
│   ├── utils/                    # Helpers, formatters, validators
│   ├── widgets/                  # Shared/reusable widgets
│   └── router/                   # GoRouter configuration
│
├── features/
│   └── <feature_name>/
│       ├── data/
│       │   ├── datasources/      # Remote & local data sources
│       │   ├── models/           # Data models (fromJson/toJson)
│       │   └── repositories/     # Repository implementations
│       ├── domain/
│       │   ├── entities/         # Pure business objects
│       │   ├── repositories/     # Repository contracts (abstract)
│       │   └── usecases/         # Business logic use cases
│       └── presentation/
│           ├── bloc/             # Blocs / Cubits + States + Events
│           ├── pages/            # Screen-level widgets
│           └── widgets/          # Feature-specific widgets
│
├── injection_container.dart      # get_it service locator setup
└── main.dart                     # App entry point
```

### Architecture Rules

1. **Dependency Rule**: Dependencies point inward only — `presentation → domain ← data`. Presentation and data layers **never** import each other.
2. **Domain layer has ZERO dependencies** on Flutter or any external package. It contains only pure Dart.
3. **Every feature** follows the `data / domain / presentation` split — no exceptions.
4. **Use cases** encapsulate a single business action and are the only way presentation communicates with domain.
5. **Repository pattern**: Domain defines abstract contracts; data layer implements them.
6. **Models vs Entities**: Models (data layer) handle serialization. Entities (domain layer) are clean business objects.

---

## 4. State Management — flutter_bloc

| Guideline                              | Detail                                                    |
|----------------------------------------|-----------------------------------------------------------|
| **Bloc vs Cubit**                      | Use Cubit for simple state; Bloc for complex event-driven flows |
| **State classes**                      | Use sealed classes or enums for states (Loading, Loaded, Error) |
| **Naming**                             | `<Feature>Cubit` / `<Feature>Bloc`, `<Feature>State`, `<Feature>Event` |
| **BlocProvider placement**             | Provide at the route level via `GoRouter`, not deep in widget trees |
| **No business logic in UI**            | Widgets only dispatch events / call cubit methods          |

---

## 5. Navigation — go_router

- Centralized route configuration in `core/router/`
- Named routes with constants (e.g., `AppRoutes.login`, `AppRoutes.brandHome`)
- Role-based route guards (redirect logic for Brand, Factory, Admin)
- Deep linking support
- Nested navigation for bottom nav bars where needed

---

## 6. Backend — Supabase

| Service          | Usage                                           |
|------------------|-------------------------------------------------|
| **Auth**         | Email/password, social login, role-based access |
| **PostgreSQL**   | All relational data (users, products, orders)   |
| **Storage**      | Product images, documents, profile photos       |
| **Realtime**     | Chat, notifications (if applicable)             |
| **Edge Functions** | Server-side logic when needed                 |

### Data Layer Rules
- All Supabase calls live in `data/datasources/` — never in presentation
- Use `Either<Failure, T>` (from `dartz` or `fpdart`) for error handling in repositories
- Handle network errors, auth errors, and validation errors with typed `Failure` classes

---

## 7. Localization — easy_localization

| Aspect           | Standard                                            |
|------------------|-----------------------------------------------------|
| **Languages**    | Arabic (ar) + English (en)                          |
| **Default**      | Arabic                                              |
| **RTL**          | Full RTL support — use `Directionality`-aware widgets |
| **Translation files** | JSON format in `assets/translations/`          |
| **Key naming**   | Dot-separated: `feature.screen.element` (e.g., `auth.login.email_label`) |
| **No hardcoded strings** | Every user-facing string must use `.tr()`   |

---

## 8. UI/UX Standards

| Aspect              | Standard                                       |
|----------------------|------------------------------------------------|
| **Design System**    | Material 3                                     |
| **Responsive**       | `flutter_screenutil` — always use `.w`, `.h`, `.sp`, `.r` |
| **Theming**          | Light + Dark mode via `ThemeData` in `core/theme/` |
| **Colors**           | Defined in `core/theme/app_colors.dart` — no inline colors |
| **Typography**       | Defined in `core/theme/app_text_styles.dart`   |
| **Spacing**          | Use consistent spacing constants               |
| **Assets**           | Organized in `assets/` with path constants in `core/constants/` |

---

## 9. Code Style & Conventions

- **Linter**: `flutter_lints` — zero warnings policy
- **Null safety**: Fully null-safe — no `!` operator unless absolutely justified
- **File naming**: `snake_case.dart`
- **Class naming**: `PascalCase`
- **Private members**: prefix with `_`
- **Max line length**: 80 characters
- **`const` constructors**: Always, where possible
- **Import order**: `dart:` → `package:` → relative imports
- **No `print()`**: Use `log()` or a proper logging package
- **Effective Dart**: Follow all [Effective Dart](https://dart.dev/effective-dart) guidelines

---

## 10. Target Platforms

| Platform    | Status        | Notes                               |
|-------------|---------------|-------------------------------------|
| **Android** | ✅ Primary    | Minimum SDK 21                      |
| **iOS**     | ✅ Primary    | Minimum iOS 13                      |
| **Web**     | 🔜 Phase 2   | Admin dashboard (later phase)       |

---

## 11. User Roles

| Role        | Platform   | Description                                         |
|-------------|------------|-----------------------------------------------------|
| **Brand**   | Mobile     | Fashion brands that place manufacturing orders       |
| **Factory** | Mobile     | Factories that receive and fulfill orders             |
| **Admin**   | Web        | Platform administration (Phase 2, not in first phase) |

---

## 12. Testing Requirements

| Type              | Requirement                                      |
|-------------------|--------------------------------------------------|
| **Unit tests**    | Required for all use cases and repositories       |
| **Bloc tests**    | Required for all Blocs/Cubits                     |
| **Widget tests**  | Encouraged for key screens                        |
| **Integration**   | For critical user flows                           |

---

## 13. Dependencies Policy

- Prefer well-maintained, popular packages with high pub.dev scores
- Pin major versions in `pubspec.yaml`
- All new dependencies require justification
- Approved core packages:

| Package              | Purpose                  |
|----------------------|--------------------------|
| `flutter_bloc`       | State management         |
| `go_router`          | Navigation               |
| `get_it`             | Dependency injection     |
| `supabase_flutter`   | Backend                  |
| `easy_localization`  | i18n / l10n              |
| `flutter_screenutil` | Responsive UI            |
| `dartz` or `fpdart`  | Functional error handling|
| `equatable`          | Value equality for states|
| `freezed` + `json_serializable` | Code generation  |
| `dio`                | HTTP client (if needed)  |

---

## 14. Version Control

- Commit messages: **conventional commits** format (`feat:`, `fix:`, `refactor:`, etc.)
- Branch naming: `feature/`, `bugfix/`, `hotfix/` prefixes
- PR reviews required before merge
- `.gitignore`: Ensure generated files, `.env`, and platform build artifacts are excluded
- **Environment variables**: Never commit secrets — use `.env` files with `flutter_dotenv`
