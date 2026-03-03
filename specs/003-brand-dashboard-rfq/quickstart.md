# Quickstart — Brand Dashboard: Search + RFQ

**Feature Branch**: `003-brand-dashboard-rfq`

## Prerequisites

1. **Flutter SDK** — 3.10.7+
2. **Supabase project** — with `profiles` table already set up (Phase 2)
3. **Logged-in Brand user** — a registered brand account for testing

## Setup Steps

### 1. Switch to the feature branch
```bash
git checkout 003-brand-dashboard-rfq
```

### 2. Install dependencies
```bash
flutter pub get
```

### 3. Run SQL migrations in Supabase

Go to **Supabase Dashboard → SQL Editor** and execute the full SQL from [data-model.md](file:///d:/Flutter/b2b_marketplace/specs/003-brand-dashboard-rfq/data-model.md#sql-migration).

This creates the `factories` and `rfq_requests` tables with RLS policies.

### 4. Create the Storage bucket

Go to **Supabase Dashboard → Storage → New Bucket**:
- **Name**: `rfq-photos`
- **Public**: Yes
- **File size limit**: 5 MB
- **Allowed MIME types**: `image/jpeg`, `image/png`, `image/webp`

### 5. Seed sample factory data

Run this in the SQL Editor (replace `owner_id` with a real factory-role profile UUID):

```sql
INSERT INTO factories (name, location, specialization, moq, avg_lead_time, rating, owner_id, photos, verified) VALUES
('Cairo Textiles Co.', 'Cairo, Egypt', ARRAY['T-shirts', 'Denim'], 200, 14, 4.5, '<FACTORY_OWNER_UUID>', ARRAY['https://placehold.co/600x400'], true),
('Alexandria Garments', 'Alexandria, Egypt', ARRAY['Jackets', 'Activewear'], 500, 21, 4.2, '<FACTORY_OWNER_UUID>', ARRAY['https://placehold.co/600x400'], true),
('Delta Fashion Hub', 'Mansoura, Egypt', ARRAY['Dresses', 'Accessories'], 100, 10, 4.8, '<FACTORY_OWNER_UUID>', ARRAY['https://placehold.co/600x400'], false),
('Suez Knitting Mill', 'Suez, Egypt', ARRAY['T-shirts', 'Activewear'], 300, 18, 3.9, '<FACTORY_OWNER_UUID>', ARRAY['https://placehold.co/600x400'], false),
('Giza Premium Wear', 'Giza, Egypt', ARRAY['Jackets', 'Denim', 'Dresses'], 150, 12, 4.6, '<FACTORY_OWNER_UUID>', ARRAY['https://placehold.co/600x400'], true);
```

### 6. Run the app
```bash
flutter run
```

Log in as a Brand user → You should see the new Brand Home screen.
