# Research — Phase 5 Production Features

**Branch**: `005-production-features` | **Date**: 2026-03-03

---

## 1. PDF Generation

### Decision
Use the `pdf` package (pub.dev: `pdf`) with `printing` for preview/share on all platforms.

### Rationale
- `pdf` is the most mature, well-maintained pure-Dart PDF engine on pub.dev (>99% popularity).
- `printing` provides cross-platform print/share/preview dialogs and works on mobile + web.
- Both are from the same author (`DavBfr`) and designed to work together.
- No native dependencies — runs in pure Dart, making it compatible with web builds.

### Alternatives Considered
| Alternative | Why Rejected |
|-------------|-------------|
| `syncfusion_flutter_pdf` | Commercial license required for production; overkill for document export |
| `flutter_html_to_pdf` | HTML-to-PDF conversion is fragile; less control over layout |
| Server-side PDF generation | Adds backend complexity; client-side is sufficient for RFQ/quote docs |

### Key Packages
- `pdf: ^3.11.1` — PDF document creation with widgets API
- `printing: ^5.13.3` — Share, preview, and print PDFs cross-platform
- `path_provider: ^2.1.4` — Access device downloads directory for saving
- `share_plus: ^10.1.3` — Native share sheet integration
- `qr_flutter: ^4.1.0` — QR code widget for embedding in PDFs (rendered as image and converted)

---

## 2. Push Notifications (FCM)

### Decision
Use Firebase Cloud Messaging (FCM) via `firebase_messaging` + `firebase_core`. Trigger notifications from Supabase Database Webhooks or Edge Functions.

### Rationale
- FCM is the industry standard for push notifications on both Android and iOS.
- `firebase_messaging` is the official FlutterFire plugin with 99%+ popularity.
- Supabase doesn't have built-in push notifications, but supports Database Webhooks and Edge Functions that can call the FCM HTTP v1 API.
- FCM's free tier is unlimited for downstream messaging.

### Alternatives Considered
| Alternative | Why Rejected |
|-------------|-------------|
| OneSignal | Adds a third-party dependency; FCM is free and sufficient |
| Supabase Edge Functions + Expo Push | Non-standard; Expo is React Native–oriented |
| Local notifications only | Doesn't cover background/terminated state; not a real push solution |

### Architecture
1. **Client (Flutter)**: `firebase_messaging` registers for push tokens on login, stores token in `profiles.fcm_token`.
2. **Server (Supabase Edge Function)**: A `send-notification` Edge Function is triggered by a Database Webhook on INSERT into `rfq_quotes` (for brand) and `rfq_requests` (for factory). The function calls the FCM HTTP v1 API.
3. **Token lifecycle**: Token refreshed on app launch, cleared on logout.

### Key Packages
- `firebase_core: ^3.8.1` — Firebase initialization
- `firebase_messaging: ^15.1.6` — FCM registration and foreground handling
- `flutter_local_notifications: ^18.0.1` — Display foreground notifications as system notifications

---

## 3. Admin Dashboard (Web-Responsive)

### Decision
Build the admin dashboard within the same Flutter codebase, using responsive layouts that adapt to web/desktop screens. Use `data_table_2` for tabular data and existing `flutter_bloc` for state management.

### Rationale
- Same codebase means shared models, auth, and DI — no duplication.
- Flutter web is already a build target for this project.
- Responsive design with `LayoutBuilder` / `MediaQuery` is sufficient; no need for a separate framework.
- The existing placeholder `AdminDashboardPage` can be expanded.

### Alternatives Considered
| Alternative | Why Rejected |
|-------------|-------------|
| Separate React/Next.js dashboard | Duplicates models, auth, increases maintenance burden |
| Supabase Studio only | No custom business logic, no branded UI |
| Flutter desktop app | Less accessible than web; web is universally accessible |

### Key Packages
- `data_table_2: ^2.5.16` — Paginated, sortable data tables for web
- `fl_chart: ^0.69.2` — Charts for revenue dashboard
- Existing: `flutter_bloc`, `go_router`, `supabase_flutter`

---

## 4. Pagination & Infinite Scroll

### Decision
Use Supabase's `.range()` API for offset-based pagination. Implement a reusable `PaginatedListView` widget using `ScrollController` detection.

### Rationale
- Supabase Dart client supports `.range(from, to)` for efficient pagination.
- Offset-based pagination is simpler to implement and sufficient for the dataset sizes expected.
- A reusable widget avoids duplicating scroll detection logic across screens.

### Alternatives Considered
| Alternative | Why Rejected |
|-------------|-------------|
| Cursor-based pagination | More complex; not needed given expected data volumes |
| `infinite_scroll_pagination` package | Adds dependency for something achievable with a simple scroll controller |

### Implementation Pattern
- Cubits maintain `currentPage`, `hasMore`, `isLoadingMore` state.
- `ScrollController.addListener` triggers `loadMore()` when near bottom.
- Data sources accept `page` and `pageSize` parameters, map to `.range()`.

---

## 5. RLS Policies for Admin Access

### Decision
Create RLS policies that grant admin users (where `profiles.role = 'admin'`) full SELECT access on all tables and UPDATE access for moderation actions. Use a Postgres function `is_admin()` for reusable checks.

### Rationale
- RLS is already enabled on all tables; admin policies must be added explicitly.
- A reusable `is_admin()` function avoids repeating the role check in every policy.
- Admin should have read access to everything but write access should be scoped to specific moderation actions.

### Security Considerations
- Admin policies use `auth.uid()` joined with `profiles.role` — not a JWT claim, so role changes take effect immediately.
- Admin cannot delete data directly; only update statuses (soft moderation).
