# Research: Supabase Authentication & Role-Based Routing

**Branch**: `002-supabase-auth-roles` | **Date**: 2026-02-26

## Research Summary

No critical unknowns were found. The spec and constitution provided clear choices for all technical decisions. Below are the resolved topics.

---

## Decision 1: Supabase Auth Flow for Email/Password

**Decision**: Use `supabase_flutter`'s built-in `Supabase.instance.client.auth.signUp()` and `signInWithPassword()` methods.

**Rationale**: `supabase_flutter` ^2.9.0 (already in pubspec) includes the full auth client. No separate HTTP calls needed. The SDK handles token storage and session refresh automatically via `SharedPreferences` under the hood.

**Alternatives considered**:
- Manual HTTP calls to Supabase REST API via `dio` — rejected; unnecessary complexity when the SDK already wraps these.
- Third-party auth wrappers — rejected; `supabase_flutter` is the official package.

---

## Decision 2: Profile Storage After Sign-Up

**Decision**: After `auth.signUp()` completes, immediately insert a row into the `profiles` table using `Supabase.instance.client.from('profiles').insert(...)`. The profile row links to `auth.users.id` via the UUID primary key.

**Rationale**: Supabase does not auto-create a `profiles` row on sign-up. The app must insert it. Doing it immediately after sign-up ensures the profile exists for subsequent role lookups.

**Alternatives considered**:
- Supabase Database trigger — viable but requires server-side config that's outside the spec's scope (schema assumed pre-existing).
- Deferred profile creation — rejected; role-based routing requires the profile immediately.

---

## Decision 3: Session Persistence

**Decision**: Rely on `supabase_flutter`'s built-in session persistence. On app start, call `Supabase.instance.client.auth.currentSession` to check for an existing session.

**Rationale**: The SDK persists sessions via `SharedPreferences` by default. No custom key-value storage needed.

**Alternatives considered**:
- Manual token storage with `shared_preferences` — rejected; duplicates SDK functionality.

---

## Decision 4: Error Handling Pattern

**Decision**: Use `dartz` `Either<Failure, T>` in repositories. The data layer catches all exceptions and returns `Left(AuthFailure(message))` or `Right(result)`.

**Rationale**: Aligns with the constitution's mandate for `dartz` or `fpdart`. `dartz` is more established in the Flutter community.

**Alternatives considered**:
- `fpdart` — viable, slightly newer API, but `dartz` is the more common choice and sufficient.
- Try/catch in Cubit — rejected; violates Clean Architecture (business logic should not handle infrastructure exceptions).

---

## Decision 5: Supabase Configuration Storage

**Decision**: Store Supabase URL and anon key as Dart constants in `lib/core/constants/supabase_constants.dart`. These values are not secrets (anon key is designed to be public; RLS policies protect data).

**Rationale**: The spec mentions ".env or constants". Since the anon key is public by design and the constitution permits constants files, a simple Dart constants file is the simplest approach. For production, the user can later migrate to `flutter_dotenv` if needed.

**Alternatives considered**:
- `flutter_dotenv` with `.env` file — viable for production, but adds a dependency and complexity that isn't needed for Phase 2.
- Compile-time `--dart-define` flags — viable but harder to manage during development.

---

## Decision 6: Cubit vs Bloc for Auth

**Decision**: Use `Cubit` (not full `Bloc` with events).

**Rationale**: Constitution says "Use Cubit for simple state; Bloc for complex event-driven flows." Auth flows are simple request/response — `signUp()`, `signIn()`, `signOut()` — with no complex event chaining.

**Alternatives considered**:
- Full Bloc with events — rejected; over-engineered for simple auth calls.
