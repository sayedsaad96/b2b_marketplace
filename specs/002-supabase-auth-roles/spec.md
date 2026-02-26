# Feature Specification: Supabase Authentication & Role-Based Routing

**Feature Branch**: `002-supabase-auth-roles`  
**Created**: 2026-02-26  
**Status**: Draft  
**Input**: User description: "Phase 2 — Auth + Roles with Supabase (no full dashboards yet)"

## User Scenarios & Testing *(mandatory)*

### User Story 1 — New User Signs Up with a Role (Priority: P1)

A new user opens the app, completes onboarding, selects their role (Brand or Factory), and is taken to the Sign Up screen. They enter their full name, email address, and password to create an account. Their chosen role is saved alongside their profile. After signing up, they are automatically logged in and navigated to the correct home screen for their role.

**Why this priority**: Account creation is the foundation of the entire platform — no other feature works without it. The role must be captured at sign-up to enable role-specific experiences in future phases.

**Independent Test**: Can be tested end-to-end by opening the app, selecting a role, filling in sign-up fields, and verifying the user lands on the correct placeholder home screen.

**Acceptance Scenarios**:

1. **Given** a new user on the Role Selection screen, **When** they select "Brand" and tap Continue, **Then** they are navigated to the Sign Up screen with the Brand role pre-selected.
2. **Given** a new user on the Sign Up screen, **When** they enter valid full name, email, and password, **Then** their account is created and a profile record is stored with the correct role.
3. **Given** a successful sign-up as a Brand, **When** authentication completes, **Then** the user is navigated to the Brand Home placeholder screen.
4. **Given** a successful sign-up as a Factory, **When** authentication completes, **Then** the user is navigated to the Factory Home placeholder screen.
5. **Given** a user on the Sign Up screen, **When** they enter an email that is already registered, **Then** a clear error message is displayed.
6. **Given** a user on the Sign Up screen, **When** they enter a weak or invalid password, **Then** a descriptive error message is shown.

---

### User Story 2 — Existing User Logs In (Priority: P1)

A returning user opens the app, navigates to the Login screen, and enters their email and password. Upon successful authentication, the system fetches their profile (including role) and navigates them to the appropriate home screen.

**Why this priority**: Login is equally critical as sign-up — returning users must be able to access the app.

**Independent Test**: Can be tested by logging in with a previously registered account and verifying navigation to the correct role-based home screen.

**Acceptance Scenarios**:

1. **Given** a registered Brand user on the Login screen, **When** they enter correct email and password, **Then** they are logged in and navigated to the Brand Home screen.
2. **Given** a registered Factory user on the Login screen, **When** they enter correct email and password, **Then** they are logged in and navigated to the Factory Home screen.
3. **Given** a registered Admin user on the Login screen, **When** they enter correct credentials, **Then** they are navigated to the Admin Dashboard placeholder screen.
4. **Given** a user on the Login screen, **When** they enter incorrect credentials, **Then** a clear error message is displayed (e.g., "Invalid email or password").
5. **Given** a user on the Login screen, **When** they leave email or password empty, **Then** form validation prevents submission and shows inline error messages.

---

### User Story 3 — Role-Based Navigation After Login (Priority: P2)

After successful authentication (sign-up or login), the system reads the user's role from their profile and routes them to the correct experience. Brand users see a Brand Home screen, Factory users see a Factory Home screen, and Admin users see an Admin Dashboard. In this phase, all three screens are simple placeholders.

**Why this priority**: This enforces role-based access control at the routing level, which is essential for the platform's security model and a prerequisite for building role-specific features in later phases.

**Independent Test**: Can be tested by logging in with accounts of different roles and verifying each lands on the correct placeholder screen.

**Acceptance Scenarios**:

1. **Given** an authenticated user with role "brand", **When** login or sign-up completes, **Then** they are navigated to `/brand/home`.
2. **Given** an authenticated user with role "factory", **When** login or sign-up completes, **Then** they are navigated to `/factory/home`.
3. **Given** an authenticated user with role "admin", **When** login or sign-up completes, **Then** they are navigated to `/admin/dashboard`.
4. **Given** an unauthenticated user, **When** they attempt to access a role-based route directly, **Then** they are redirected to the login screen.

---

### User Story 4 — User Signs Out (Priority: P2)

An authenticated user can sign out from their home screen. Upon signing out, their session is cleared and they are returned to the login screen.

**Why this priority**: Sign-out is a standard auth feature that ensures users can switch accounts or secure their session.

**Independent Test**: Can be tested by logging in, tapping a sign-out action, and verifying the user is returned to the login screen and cannot access protected routes.

**Acceptance Scenarios**:

1. **Given** an authenticated user on any home screen, **When** they tap sign out, **Then** their session is cleared and they are navigated to the login screen.
2. **Given** a user who has just signed out, **When** they attempt to navigate back to a protected route, **Then** they are redirected to the login screen.

---

### User Story 5 — Session Persistence (Priority: P3)

When a user closes the app and reopens it, if their session is still valid they should be automatically routed to their role-based home screen without needing to log in again.

**Why this priority**: This improves user experience by avoiding repeated logins, but is not critical for initial functionality.

**Independent Test**: Can be tested by logging in, closing the app, reopening it, and verifying the user lands on their home screen without re-entering credentials.

**Acceptance Scenarios**:

1. **Given** a user with a valid session, **When** they reopen the app, **Then** they are automatically navigated to their role-based home screen.
2. **Given** a user whose session has expired, **When** they reopen the app, **Then** they are redirected to the login screen.

---

### Edge Cases

- What happens when the user's profile record is missing from the database after login? → Display an error and sign the user out.
- What happens when the network is unavailable during sign-up or login? → Display a clear "no connection" error message.
- What happens if the role value in the profile is invalid or unrecognized? → Treat as an error, sign user out, and display a message.
- What happens if the user taps sign-up/login rapidly multiple times? → Prevent duplicate submissions (disable button while loading).

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST allow new users to create an account with full name, email, password, and role (Brand or Factory).
- **FR-002**: System MUST allow existing users to log in with email and password.
- **FR-003**: System MUST store the user's role (brand, factory, or admin) in their profile upon registration.
- **FR-004**: System MUST fetch the user's profile and role after successful authentication.
- **FR-005**: System MUST navigate users to the correct home screen based on their role (Brand Home, Factory Home, or Admin Dashboard).
- **FR-006**: System MUST allow users to sign out, clearing their session.
- **FR-007**: System MUST validate form inputs (email format, password requirements, non-empty fields) before submission.
- **FR-008**: System MUST display clear, user-friendly error messages for authentication failures (wrong credentials, duplicate email, network errors).
- **FR-009**: System MUST persist user sessions so returning users are auto-logged in when reopening the app.
- **FR-010**: System MUST redirect unauthenticated users to the login screen when they attempt to access protected routes.
- **FR-011**: System MUST pass the selected role from the Role Selection screen through to the Sign Up flow.
- **FR-012**: System MUST provide placeholder screens (Brand Home, Factory Home, Admin Dashboard) that simply display the screen name for now.

### Key Entities

- **User Profile**: Represents a registered user's identity — includes full name, role, and account creation date. Linked to the authentication identity.
- **User Role**: An enumeration of platform roles — Brand (fashion brands placing orders), Factory (manufacturers fulfilling orders), Admin (platform administrators).
- **Auth Session**: Represents an active authenticated session — used to determine if a user is logged in and to fetch their profile.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Users can complete the sign-up flow (role selection → sign up → home screen) in under 60 seconds.
- **SC-002**: Users can log in and reach their role-based home screen in under 15 seconds.
- **SC-003**: 100% of authentication error scenarios display a meaningful, user-readable error message (not raw system errors).
- **SC-004**: Users who close and reopen the app are automatically logged in 100% of the time while their session remains valid.
- **SC-005**: Users of each role (Brand, Factory, Admin) are always routed to their correct home screen — zero cross-role routing errors.

## Assumptions

- The Supabase `profiles` table (with `id`, `full_name`, `role`, `created_at`) already exists or will be created manually in the Supabase dashboard before implementation begins.
- Admin users are created manually in the database — there is no self-service admin sign-up in the app.
- Password requirements follow Supabase's default minimum (6 characters).
- The existing Role Selection screen only exposes Brand and Factory options; Admin is not selectable during sign-up.
- The Sign Up and Login screens need to be consistent with the existing app's design system (Material 3, bilingual AR/EN, RTL support).
- The placeholder home screens (Brand Home, Factory Home, Admin Dashboard) are simple scaffold screens showing the role name — no functional UI is built yet.
