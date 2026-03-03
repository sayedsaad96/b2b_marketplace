# Implementation Plan: Phase 5 — Production Features

**Branch**: `005-production-features` | **Date**: 2026-03-03 | **Spec**: [spec.md](file:///d:/Flutter/b2b_marketplace/specs/005-production-features/spec.md)  
**Input**: Feature specification from `specs/005-production-features/spec.md`

---

## Summary

Phase 5 adds four major production capabilities to the B2B Marketplace: **(1)** Professional PDF export for RFQs and quotes, **(2)** Firebase Cloud Messaging push notifications, **(3)** A full admin dashboard for web, and **(4)** UX polish including pagination, pull-to-refresh, and error boundaries across all screens. The implementation follows the existing Clean Architecture patterns using `flutter_bloc`, `get_it`, `go_router`, and `supabase_flutter`.

## Technical Context

**Language/Version**: Dart 3.10.7 / Flutter  
**Primary Dependencies**: `flutter_bloc`, `go_router`, `get_it`, `supabase_flutter`, `equatable`, `dartz`  
**New Dependencies**: `pdf`, `printing`, `path_provider`, `share_plus`, `qr_flutter`, `firebase_core`, `firebase_messaging`, `flutter_local_notifications`, `data_table_2`, `fl_chart`  
**Storage**: Supabase (PostgreSQL) + Supabase Storage  
**Testing**: `flutter_test`, `dart analyze`, `flutter build web`  
**Target Platform**: Android, iOS, Web (Admin Dashboard)  
**Project Type**: Mobile app + web admin  

## Constitution Check

*Constitution is a placeholder template with no active gates. No violations.*

---

## Project Structure

### Documentation (this feature)

```text
specs/005-production-features/
├── plan.md              # This file
├── research.md          # Technology decisions
├── data-model.md        # New tables, columns, RLS, SQL migration
├── quickstart.md        # Setup guide
└── checklists/
    └── requirements.md  # Spec quality checklist
```

### Source Code (repository root)

```text
lib/
├── core/
│   ├── constants/
│   │   └── app_routes.dart          # [MODIFY] Add admin sub-routes
│   ├── router/
│   │   └── app_router.dart          # [MODIFY] Add admin sub-routes, role guard
│   ├── services/
│   │   ├── pdf_service.dart         # [NEW] PDF generation service
│   │   └── notification_service.dart # [NEW] FCM initialization & token management
│   └── widgets/
│       ├── paginated_list_view.dart  # [NEW] Reusable infinite-scroll widget
│       └── error_boundary.dart      # [NEW] Error display with retry
│
├── features/
│   ├── pdf_export/
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── pdf_storage_datasource.dart   # [NEW] Upload to rfq-pdfs bucket
│   │   ├── domain/
│   │   │   ├── usecases/
│   │   │   │   ├── generate_rfq_pdf_usecase.dart # [NEW]
│   │   │   │   └── generate_quote_pdf_usecase.dart # [NEW]
│   │   │   └── repositories/
│   │   │       └── pdf_repository.dart           # [NEW]
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── pdf_export_cubit.dart         # [NEW]
│   │       │   └── pdf_export_state.dart         # [NEW]
│   │       └── widgets/
│   │           └── pdf_export_button.dart        # [NEW] Reusable export button
│   │
│   ├── notifications/
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── notification_remote_datasource.dart # [NEW] CRUD for notifications table
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── app_notification.dart         # [NEW]
│   │   │   ├── repositories/
│   │   │   │   └── notification_repository.dart  # [NEW]
│   │   │   └── usecases/
│   │   │       ├── get_notifications_usecase.dart # [NEW]
│   │   │       └── mark_notification_read_usecase.dart # [NEW]
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── notification_cubit.dart       # [NEW]
│   │       │   └── notification_state.dart       # [NEW]
│   │       └── widgets/
│   │           └── notification_badge.dart       # [NEW] AppBar badge
│   │
│   ├── admin/
│   │   ├── data/
│   │   │   └── datasources/
│   │   │       └── admin_remote_datasource.dart  # [NEW] Admin queries
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── admin_action.dart             # [NEW]
│   │   │   ├── repositories/
│   │   │   │   └── admin_repository.dart         # [NEW]
│   │   │   └── usecases/
│   │   │       ├── get_all_users_usecase.dart    # [NEW]
│   │   │       ├── get_all_rfqs_usecase.dart     # [NEW]
│   │   │       ├── get_all_quotes_usecase.dart   # [NEW]
│   │   │       ├── get_revenue_stats_usecase.dart # [NEW]
│   │   │       ├── verify_factory_usecase.dart   # [NEW]
│   │   │       └── moderate_content_usecase.dart # [NEW]
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── admin_users_cubit.dart        # [NEW]
│   │       │   ├── admin_rfqs_cubit.dart         # [NEW]
│   │       │   ├── admin_revenue_cubit.dart      # [NEW]
│   │       │   └── admin_moderation_cubit.dart   # [NEW]
│   │       ├── pages/
│   │       │   └── admin_dashboard_page.dart     # [MODIFY] Replace placeholder with full dashboard
│   │       └── widgets/
│   │           ├── admin_sidebar.dart            # [NEW] Web navigation sidebar
│   │           ├── users_table.dart              # [NEW]
│   │           ├── rfqs_table.dart               # [NEW]
│   │           ├── quotes_table.dart             # [NEW]
│   │           ├── revenue_charts.dart           # [NEW]
│   │           └── factory_verification_card.dart # [NEW]
│   │
│   ├── brand/presentation/
│   │   ├── pages/
│   │   │   ├── brand_home_page.dart             # [MODIFY] Add pull-to-refresh, notification badge
│   │   │   ├── factory_search_page.dart         # [MODIFY] Add pagination
│   │   │   └── my_rfqs_page.dart                # [MODIFY] Add pagination, pull-to-refresh
│   │   └── bloc/
│   │       ├── factory_search_cubit.dart         # [MODIFY] Add pagination support
│   │       └── rfq_cubit.dart                   # [MODIFY] Add pagination support
│   │
│   └── factory_dashboard/presentation/
│       ├── pages/
│       │   ├── rfq_inbox_page.dart              # [MODIFY] Add pagination, pull-to-refresh
│       │   ├── active_orders_page.dart          # [MODIFY] Add pagination, pull-to-refresh
│       │   └── factory_dashboard_page.dart      # [MODIFY] Add notification badge
│       └── bloc/
│           └── rfq_inbox_cubit.dart             # [MODIFY] Add pagination support
│
├── injection_container.dart                      # [MODIFY] Register Phase 5 dependencies
└── main.dart                                     # [MODIFY] Initialize Firebase, notification service
```

---

## Proposed Changes (Implementation Steps)

### Step 1: Supabase Migration + Storage Bucket

> **Priority**: Must be done first — all other steps depend on the schema.

#### [MODIFY] Supabase Database
- Execute the full SQL migration from [data-model.md](file:///d:/Flutter/b2b_marketplace/specs/005-production-features/data-model.md)
- Add `fcm_token`, `is_verified`, `suspended_at` columns to `profiles`
- Create `admin_actions` and `notifications` tables with RLS
- Create `is_admin()` helper function
- Add admin RLS policies to all existing tables
- Create `rfq-pdfs` storage bucket

---

### Step 2: Add New Package Dependencies

#### [MODIFY] [pubspec.yaml](file:///d:/Flutter/b2b_marketplace/pubspec.yaml)
Add the following dependencies:

```yaml
# PDF Export
pdf: ^3.11.1
printing: ^5.13.3
path_provider: ^2.1.4
share_plus: ^10.1.3
qr_flutter: ^4.1.0

# Push Notifications
firebase_core: ^3.8.1
firebase_messaging: ^15.1.6
flutter_local_notifications: ^18.0.1

# Admin Dashboard
data_table_2: ^2.5.16
fl_chart: ^0.69.2
```

---

### Step 3: PDF Export Feature

#### [NEW] `lib/core/services/pdf_service.dart`
- `generateRfqPdf(RfqRequest rfq, ProfileEntity brand)` → returns `Uint8List`
- `generateQuotePdf(RfqQuote quote, RfqRequest rfq, ProfileEntity factory)` → returns `Uint8List`
- Professional layout: company logo, details header, itemized content, QR code, signature space
- Uses `pdf` package widgets: `Document`, `Page`, `Header`, `Table`, `BarcodeWidget`

#### [NEW] `lib/features/pdf_export/data/datasources/pdf_storage_datasource.dart`
- `uploadPdf(String userId, String docType, String entityId, Uint8List bytes)` → uploads to `rfq-pdfs` bucket
- Returns public URL of uploaded PDF

#### [NEW] `lib/features/pdf_export/domain/repositories/pdf_repository.dart`
- Contract: `generateAndSaveRfqPdf()`, `generateAndSaveQuotePdf()`, `sharePdf()`

#### [NEW] `lib/features/pdf_export/domain/usecases/generate_rfq_pdf_usecase.dart`
- Orchestrates PDF generation + optional upload + return bytes

#### [NEW] `lib/features/pdf_export/domain/usecases/generate_quote_pdf_usecase.dart`
- Same pattern for quote PDFs

#### [NEW] `lib/features/pdf_export/presentation/bloc/pdf_export_cubit.dart`
- States: `PdfExportInitial`, `PdfExportGenerating`, `PdfExportReady(Uint8List bytes)`, `PdfExportError`
- Actions: `generateRfqPdf(rfqId)`, `generateQuotePdf(quoteId)`, `sharePdf()`, `savePdf()`

#### [NEW] `lib/features/pdf_export/presentation/widgets/pdf_export_button.dart`
- Reusable `ElevatedButton.icon` that triggers PDF generation and shows preview/share/save options

---

### Step 4: Push Notifications Feature

#### [NEW] `lib/core/services/notification_service.dart`
- Initialize Firebase in `main.dart`
- `requestPermission()` — asks for notification permission
- `getToken()` → returns FCM token
- `saveTokenToSupabase(String token)` — updates `profiles.fcm_token`
- `onTokenRefresh(callback)` — listens for token changes
- `setupForegroundHandler()` — handles in-app notifications via `flutter_local_notifications`
- `setupBackgroundHandler()` — static top-level function for background messages
- `handleNotificationTap(RemoteMessage)` — deep-links to relevant screen via `GoRouter`

#### [NEW] `lib/features/notifications/data/datasources/notification_remote_datasource.dart`
- `getNotifications(userId, {page, pageSize})` → fetch from `notifications` table
- `markAsRead(notificationId)` → update `is_read`
- `getUnreadCount(userId)` → count query

#### [NEW] `lib/features/notifications/domain/entities/app_notification.dart`
- Entity: `id`, `userId`, `type`, `title`, `body`, `resourceType`, `resourceId`, `isRead`, `createdAt`

#### [NEW] `lib/features/notifications/domain/usecases/get_notifications_usecase.dart` + `mark_notification_read_usecase.dart`

#### [NEW] `lib/features/notifications/presentation/bloc/notification_cubit.dart`
- Loads unread count on app start, refreshes periodically
- States: `NotificationInitial`, `NotificationLoaded(count, notifications)`

#### [NEW] `lib/features/notifications/presentation/widgets/notification_badge.dart`
- AppBar icon with red badge showing unread count

#### [MODIFY] `lib/main.dart`
- Add `Firebase.initializeApp()` before `runApp()`
- Initialize `NotificationService` after auth check

---

### Step 5: Admin Dashboard (Web-Responsive)

#### [NEW] `lib/features/admin/data/datasources/admin_remote_datasource.dart`
- `getAllUsers({page, pageSize, search, roleFilter})` — paginated profiles query
- `getAllRfqs({page, pageSize, statusFilter})` — paginated RFQ query with quote counts
- `getAllQuotes({page, pageSize, statusFilter})` — paginated quotes with RFQ info
- `getRevenueStats()` — aggregated: total accepted quotes, estimated revenue, monthly trends
- `verifyFactory(factoryId, approved, reason)` — update `is_verified` + insert `admin_actions`
- `suspendUser(userId, reason)` — update `suspended_at` + insert `admin_actions`
- `getUnverifiedFactories()` — factories where `is_verified = false`

#### [NEW] `lib/features/admin/domain/` — entities, repositories, use cases
- `AdminAction` entity
- `AdminRepository` contract
- Use cases: `GetAllUsersUseCase`, `GetAllRfqsUseCase`, `GetAllQuotesUseCase`, `GetRevenueStatsUseCase`, `VerifyFactoryUseCase`, `ModerateContentUseCase`

#### [NEW] `lib/features/admin/presentation/bloc/`
- `AdminUsersCubit` — manages users table state with search/filter/pagination
- `AdminRfqsCubit` — manages RFQs overview with filters
- `AdminRevenueCubit` — loads revenue aggregates and chart data
- `AdminModerationCubit` — manages verification queue and moderation actions

#### [MODIFY] [admin_dashboard_page.dart](file:///d:/Flutter/b2b_marketplace/lib/features/admin/presentation/pages/admin_dashboard_page.dart)
- Replace placeholder with full responsive layout:
  - **Sidebar** navigation (Users, RFQs, Quotes, Revenue, Verification, Moderation)
  - **Content area** renders the active section
  - Responsive: sidebar collapses to drawer on mobile

#### [NEW] `lib/features/admin/presentation/widgets/`
- `admin_sidebar.dart` — Navigation rail / drawer with sections
- `users_table.dart` — `DataTable2` with search, role filter, pagination
- `rfqs_table.dart` — RFQ overview with status badges, quote counts
- `quotes_table.dart` — Quote overview with pricing, status
- `revenue_charts.dart` — `fl_chart` line/bar charts for trends
- `factory_verification_card.dart` — Review card with approve/reject actions

#### [MODIFY] [app_routes.dart](file:///d:/Flutter/b2b_marketplace/lib/core/constants/app_routes.dart)
- Add: `adminUsers`, `adminRfqs`, `adminQuotes`, `adminRevenue`, `adminVerification`

#### [MODIFY] [app_router.dart](file:///d:/Flutter/b2b_marketplace/lib/core/router/app_router.dart)
- Add routes for admin sub-sections
- Add admin role guard (redirect non-admins away from `/admin/*`)

---

### Step 6: Pagination & Pull-to-Refresh (Polish)

#### [NEW] `lib/core/widgets/paginated_list_view.dart`
- Reusable widget accepting: `itemBuilder`, `itemCount`, `onLoadMore`, `onRefresh`, `hasMore`, `isLoadingMore`
- Wraps `RefreshIndicator` + `ListView.builder` + scroll position detection
- Shows loading indicator at bottom when `isLoadingMore`

#### [NEW] `lib/core/widgets/error_boundary.dart`
- Displays error message + retry button
- Optionally shows previously loaded content underneath

#### [MODIFY] `lib/features/brand/presentation/bloc/factory_search_cubit.dart`
- Add `page`, `hasMore`, `isLoadingMore` state fields
- Add `loadMore()` method using `.range()` pagination
- Modify `searchFactories()` to reset pagination

#### [MODIFY] `lib/features/brand/presentation/pages/factory_search_page.dart`
- Replace `ListView` with `PaginatedListView`
- Add `RefreshIndicator`

#### [MODIFY] `lib/features/brand/presentation/bloc/rfq_cubit.dart`
- Add pagination support to `getMyRfqs()`

#### [MODIFY] `lib/features/brand/presentation/pages/my_rfqs_page.dart`
- Replace with `PaginatedListView` + pull-to-refresh

#### [MODIFY] `lib/features/factory_dashboard/presentation/bloc/rfq_inbox_cubit.dart`
- Add pagination support

#### [MODIFY] `lib/features/factory_dashboard/presentation/pages/rfq_inbox_page.dart`
- Replace with `PaginatedListView` + pull-to-refresh

#### [MODIFY] `lib/features/factory_dashboard/presentation/pages/active_orders_page.dart`
- Add pull-to-refresh + pagination

---

### Step 7: Dependency Injection & Wiring

#### [MODIFY] [injection_container.dart](file:///d:/Flutter/b2b_marketplace/lib/injection_container.dart)
- Register all new datasources, repositories, use cases, and cubits for:
  - PDF Export feature
  - Notifications feature
  - Admin feature
  - `NotificationService`
  - `PdfService`

---

### Step 8: Final Integration & Cleanup

#### [MODIFY] Various pages
- Add `PdfExportButton` to RFQ detail and Quote detail screens
- Add `NotificationBadge` to `BrandHomePage` and `FactoryDashboardPage` AppBars
- Ensure all list screens use `PaginatedListView`
- Run `dart analyze` and fix all warnings
- Run `flutter build web` to verify admin dashboard builds

---

## Verification Plan

### Automated Tests

```bash
# Static analysis — must pass with 0 errors
dart analyze

# Build verification — web target (admin dashboard)
flutter build web

# Build verification — APK target
flutter build apk --debug
```

### Manual Verification

1. **PDF Export**:
   - Log in as a brand user → navigate to an RFQ detail → tap "Export PDF" → verify PDF opens in preview with company details, items, QR code, and signature space → tap Share → verify native share sheet opens → tap Save → verify file appears in device downloads.

2. **Push Notifications**:
   - Log in on Device A as a brand → log in on Device B as a factory → on Device B, submit a quote for the brand's RFQ → verify Device A receives a push notification titled "New Quote Received" → tap the notification → verify it navigates to the quote detail screen.

3. **Admin Dashboard**:
   - Open the app in Chrome (`flutter run -d chrome`) → log in as an admin user → verify the sidebar shows Users, RFQs, Quotes, Revenue, Verification sections → navigate to Users → verify paginated table loads with search/filter → navigate to Revenue → verify charts render → navigate to Verification → approve a factory → verify its status changes to "Verified".

4. **Pagination**:
   - On Factory Search page, scroll to the bottom → verify more factories load with a loading indicator → pull down from the top → verify the list refreshes.

5. **Error Handling**:
   - Disconnect the internet → navigate to a list screen → verify a friendly error message appears with a "Retry" button → reconnect → tap Retry → verify data loads.

---

## Complexity Tracking

*No constitution violations to justify.*
