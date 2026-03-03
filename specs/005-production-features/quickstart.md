# Quickstart — Phase 5 Production Features

**Branch**: `005-production-features` | **Date**: 2026-03-03

---

## Prerequisites

1. Flutter SDK ≥ 3.10.7
2. Supabase project with `rfq_requests`, `rfq_quotes`, `messages`, `profiles`, `factories` tables
3. Firebase project with FCM enabled (for push notifications)
4. Admin user with `role = 'admin'` in `profiles` table

## Setup Steps

### 1. Install New Dependencies

```bash
flutter pub add pdf printing path_provider share_plus qr_flutter
flutter pub add firebase_core firebase_messaging flutter_local_notifications
flutter pub add data_table_2 fl_chart
```

### 2. Run Supabase Migration

Execute the SQL from `data-model.md` against your Supabase database:
- Adds `fcm_token`, `is_verified`, `suspended_at` columns to `profiles`
- Creates `admin_actions` and `notifications` tables
- Creates `is_admin()` helper function
- Adds admin RLS policies to all existing tables
- Creates `rfq-pdfs` storage bucket

### 3. Firebase Setup

1. Add `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) from Firebase Console
2. Update `android/build.gradle` and `ios/Runner/Info.plist` per FlutterFire docs
3. For web: add Firebase config to `web/index.html`

### 4. Build & Run

```bash
# Mobile
flutter run

# Web (Admin Dashboard)
flutter run -d chrome
```

## Feature Access

| Feature | Access Point | Role |
|---------|-------------|------|
| PDF Export | RFQ detail / Quote detail screens | Brand / Factory |
| Push Notifications | Automatic on login | Brand / Factory |
| Admin Dashboard | `/admin/dashboard` route | Admin |
| Pagination | All list screens | All |
