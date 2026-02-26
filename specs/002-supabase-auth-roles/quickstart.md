# Quickstart: Supabase Authentication & Role-Based Routing

**Branch**: `002-supabase-auth-roles` | **Date**: 2026-02-26

## Prerequisites

1. **Supabase project** with the `profiles` table created (see `data-model.md` for schema)
2. **RLS policies** enabled on `profiles` table
3. **Supabase URL and anon key** available from Supabase dashboard → Settings → API

## Setup Steps

### 1. Update Supabase Constants

Edit `lib/core/constants/supabase_constants.dart` and replace placeholder values:

```dart
class SupabaseConstants {
  SupabaseConstants._();
  static const String url = 'https://YOUR_PROJECT.supabase.co';
  static const String anonKey = 'YOUR_ANON_KEY';
}
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

### 4. Test the Flow

1. App opens → Splash → Onboarding → Role Selection
2. Select **Brand** or **Factory** → tap **Continue**
3. Fill in Sign Up form (name, email, password) → tap **Sign Up**
4. You should land on the placeholder home screen for your role
5. Tap **Sign Out** → you return to Login screen
6. Log back in with your credentials → verify correct home screen

## Key Files

| Purpose | Path |
|---------|------|
| Supabase init | `lib/main.dart` |
| Config | `lib/core/constants/supabase_constants.dart` |
| Auth datasource | `lib/features/auth/data/datasources/auth_remote_datasource.dart` |
| Auth repository | `lib/features/auth/data/repositories/auth_repository_impl.dart` |
| Auth cubit | `lib/features/auth/presentation/bloc/auth_cubit.dart` |
| Login screen | `lib/features/auth/presentation/pages/login_page.dart` |
| Sign up screen | `lib/features/auth/presentation/pages/sign_up_page.dart` |
| Routes | `lib/core/router/app_router.dart` |
| DI setup | `lib/injection_container.dart` |

## Troubleshooting

| Issue | Cause | Fix |
|-------|-------|-----|
| "Invalid API key" on sign-up | Wrong anon key in constants | Copy correct key from Supabase dashboard |
| "relation profiles does not exist" | Table not created | Run the SQL from `data-model.md` in Supabase SQL Editor |
| Sign-up works but profile not saved | Missing RLS INSERT policy | Add the INSERT policy from `data-model.md` |
| Session not persisting | App in web mode without cookies | Test on Android/iOS emulator |
