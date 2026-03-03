# Quickstart — Factory Dashboard & Chat

**Branch**: `004-factory-dashboard-chat` | **Date**: 2026-02-28

## Prerequisites

1. Supabase project configured (from Phase 2/3)
2. Flutter SDK installed
3. Phase 3 code (brand dashboard) complete and working

## Setup Steps

### 1. Run SQL Migration

Copy the SQL from [data-model.md](file:///d:/Flutter/b2b_marketplace/specs/004-factory-dashboard-chat/data-model.md) and execute in Supabase SQL Editor to create:
- `rfq_quotes` table with RLS policies
- `messages` table with RLS policies and Realtime enabled

### 2. Create Storage Buckets

In Supabase Dashboard → Storage:
- Create `factory-photos` bucket (public, 5MB, images only)
- Create `chat-images` bucket (private, 5MB, images only)

### 3. Install Dependencies

```bash
cd d:\Flutter\b2b_marketplace
flutter pub get
```

No new pub dependencies needed — `image_picker`, `cached_network_image`, and `uuid` were added in Phase 3.

### 4. Run the App

```bash
flutter run -d windows
```

### 5. Test Factory Flow

1. Log in as a factory user
2. Verify Factory Dashboard Home shows stats and recent RFQs
3. Navigate to RFQ Inbox → Submit a quote
4. Open My Profile → Edit details and upload photos
5. Open chat on any RFQ → Send text and image messages
6. Navigate to Active Orders → Verify accepted quotes appear
