# Phase 1 — Project Scaffolding & Onboarding UI

> **Constitution**: [constitution.md](file:///d:/Sayed/Flutter/b2b_marketplace/.speckit/constitution.md)
> **Scope**: Foundation setup + first screens (Splash → Onboarding → Role Selection). No backend integration yet.

---

## Summary

Phase 1 establishes the entire project skeleton — folder structure, dependencies, core infrastructure (theme, localization, routing, DI), and the first three UI screens the user sees. After this phase the app launches, shows a splash screen, walks through onboarding, and lets the user pick their role (Brand / Factory). No Supabase calls or auth logic — that's Phase 2.

---

## Proposed Changes (15 Tasks)

### Task 1 — Create Clean Architecture Folder Structure

Create the full directory tree under `lib/` as defined in the constitution:

```
lib/
├── core/
│   ├── constants/
│   ├── error/
│   ├── network/
│   ├── theme/
│   ├── usecase/
│   ├── utils/
│   ├── widgets/
│   └── router/
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       ├── pages/
│   │       └── widgets/
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── bloc/
│   │       ├── pages/
│   │       └── widgets/
│   └── role_selection/
│       └── presentation/
│           ├── pages/
│           └── widgets/
├── injection_container.dart   (empty placeholder)
└── main.dart                  (will be rewritten)
```

Also create:
```
assets/
├── images/
├── icons/
├── translations/
│   ├── ar.json
│   └── en.json
└── fonts/
```

---

### Task 2 — Configure `pubspec.yaml`

Add all Phase 1 dependencies (pinned major versions):

| Package              | Purpose                        |
|----------------------|--------------------------------|
| `flutter_bloc`       | State management               |
| `go_router`          | Navigation                     |
| `get_it`             | Dependency injection           |
| `easy_localization`  | AR/EN localization             |
| `flutter_screenutil` | Responsive sizing              |
| `equatable`          | Value equality                 |
| `flutter_svg`        | SVG asset rendering            |
| `smooth_page_indicator` | Onboarding page dots        |

Register `assets/translations/`, `assets/images/`, `assets/icons/` in the flutter assets section. Run `flutter pub get`.

> [!NOTE]
> Supabase, dartz, freezed, etc. are **not** needed until Phase 2.

---

### Task 3 — Core Constants

Create foundational constant files:

#### [NEW] `lib/core/constants/app_strings.dart`
- App name, fallback strings (non-localized technical strings only)

#### [NEW] `lib/core/constants/app_assets.dart`
- Static path references: `AppAssets.logo`, `AppAssets.onboarding1`, etc.

#### [NEW] `lib/core/constants/app_routes.dart`
- Route name constants: `splash`, `onboarding`, `roleSelection`

---

### Task 4 — Implement AppTheme (Light + Dark)

#### [NEW] `lib/core/theme/app_colors.dart`
- Define the full color palette (primary, secondary, surface, error, etc.) for both light and dark modes
- No inline `Color(0xFF...)` anywhere else in the app

#### [NEW] `lib/core/theme/app_text_styles.dart`
- Typography scale using `flutter_screenutil` `.sp` units
- Heading, body, caption, button styles

#### [NEW] `lib/core/theme/app_theme.dart`
- `ThemeData` for light mode and dark mode
- Material 3 enabled (`useMaterial3: true`)
- Compose from `app_colors.dart` and `app_text_styles.dart`

---

### Task 5 — Configure easy_localization

#### [NEW] `assets/translations/ar.json`
- All Phase 1 strings in Arabic (splash, onboarding, role selection)

#### [NEW] `assets/translations/en.json`
- Same keys in English

#### Key structure:
```json
{
  "app.name": "B2B Marketplace",
  "splash.tagline": "...",
  "onboarding.title_1": "...",
  "onboarding.desc_1": "...",
  "onboarding.title_2": "...",
  "onboarding.desc_2": "...",
  "onboarding.title_3": "...",
  "onboarding.desc_3": "...",
  "onboarding.next": "...",
  "onboarding.skip": "...",
  "onboarding.get_started": "...",
  "role_selection.title": "...",
  "role_selection.brand": "...",
  "role_selection.factory": "...",
  "role_selection.continue": "..."
}
```

---

### Task 6 — Configure `flutter_screenutil`

Initialize `ScreenUtil` in `main.dart` with a design size (e.g., 375×812 for iPhone standard). Wrap the `MaterialApp.router` with `ScreenUtilInit`.

---

### Task 7 — Setup `get_it` Dependency Injection

#### [NEW] `lib/injection_container.dart`
- Initialize `GetIt.instance`
- Phase 1: register only the `GoRouter` instance
- Provide an `init()` function called from `main.dart` before `runApp`

---

### Task 8 — Rewrite `main.dart`

Replace the default counter app with the constitution-compliant entry point:

1. `WidgetsFlutterBinding.ensureInitialized()`
2. `await EasyLocalization.ensureInitialized()`
3. Call `initDependencies()` (from `injection_container.dart`)
4. `runApp()` wrapped in `EasyLocalization` widget
5. Root widget: `ScreenUtilInit` → `MaterialApp.router` with `GoRouter`, theme, localization delegates

---

### Task 9 — Setup GoRouter

#### [NEW] `lib/core/router/app_router.dart`
- Define the `GoRouter` instance with initial route `/splash`
- Routes:
  - `/splash` → `SplashPage`
  - `/onboarding` → `OnboardingPage`
  - `/role-selection` → `RoleSelectionPage`
- No guards yet (Phase 2)

---

### Task 10 — Core Reusable Widgets

#### [NEW] `lib/core/widgets/custom_button.dart`
- Primary and secondary button variants
- Full-width, responsive sizing via `flutter_screenutil`
- Localized text via `.tr()`

#### [NEW] `lib/core/widgets/responsive_text.dart` (optional)
- Helper for responsive text with `.sp`

---

### Task 11 — Build Splash Screen UI

#### [NEW] `lib/features/splash/presentation/pages/splash_page.dart`
- App logo centered
- App name / tagline text (localized)
- Auto-navigate to `/onboarding` after 2–3 seconds (simple `Future.delayed`, no Bloc needed)
- Smooth fade-in animation for the logo

---

### Task 12 — Onboarding Cubit

#### [NEW] `lib/features/onboarding/presentation/bloc/onboarding_cubit.dart`
#### [NEW] `lib/features/onboarding/presentation/bloc/onboarding_state.dart`
- Track current page index
- Methods: `nextPage()`, `previousPage()`, `skip()`

---

### Task 13 — Build Onboarding Screens UI

#### [NEW] `lib/features/onboarding/presentation/pages/onboarding_page.dart`
- `PageView` with 3 onboarding slides
- Each slide: illustration image + title + description (all localized)
- `SmoothPageIndicator` dots
- "Next" / "Skip" / "Get Started" buttons
- Full RTL support

#### [NEW] `lib/features/onboarding/presentation/widgets/onboarding_slide.dart`
- Reusable single-slide widget (image, title, description)

---

### Task 14 — Build Role Selection Screen UI

#### [NEW] `lib/features/role_selection/presentation/pages/role_selection_page.dart`
- Title: "Choose your role" (localized)
- Two large cards: **Brand** and **Factory** with icons/illustrations
- Each card has a role name + short description
- "Continue" button (disabled until role is selected)
- Navigate to placeholder or auth screen (Phase 2 destination)

#### [NEW] `lib/features/role_selection/presentation/widgets/role_card.dart`
- Reusable role card widget with selection state

---

### Task 15 — Generate Onboarding & Splash Assets

- Use the `generate_image` tool to create:
  - App logo placeholder
  - 3 onboarding illustrations (fashion/manufacturing themed)
  - Role icons (Brand briefcase, Factory building)
- Place in `assets/images/`
- Register in `pubspec.yaml`

---

## Verification Plan

### Automated
```bash
flutter analyze          # Must produce zero warnings/errors
dart format . --set-exit-if-changed   # All files formatted
flutter test             # Existing tests must still pass
```

### Manual (User)
1. Run `flutter run` on Android emulator or physical device
2. Verify: splash screen appears → auto-navigates to onboarding after ~3s
3. Verify: onboarding swipes through 3 pages with correct AR or EN text
4. Verify: "Skip" and "Get Started" navigate to role selection
5. Verify: role selection shows Brand/Factory cards, can select one, and "Continue" button activates
6. Verify: switch device language to English → all strings update
7. Verify: RTL layout renders correctly in Arabic mode (text right-aligned, swipe direction, etc.)
