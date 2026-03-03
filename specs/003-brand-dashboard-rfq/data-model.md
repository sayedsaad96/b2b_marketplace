# Data Model — Brand Dashboard: Search + RFQ

**Created**: 2026-02-28
**Feature Branch**: `003-brand-dashboard-rfq`

---

## Entity: Factory

| Field            | Type            | Constraints                          |
|------------------|-----------------|--------------------------------------|
| `id`             | UUID            | PK, default `gen_random_uuid()`      |
| `name`           | text            | NOT NULL                             |
| `location`       | text            | NOT NULL                             |
| `specialization` | text[]          | NOT NULL, default `'{}'`             |
| `moq`            | integer         | NOT NULL, default `1`                |
| `avg_lead_time`  | integer         | NOT NULL (days)                      |
| `rating`         | numeric(2,1)    | default `0.0`, CHECK 0–5            |
| `owner_id`       | UUID            | FK → `profiles.id`, NOT NULL         |
| `photos`         | text[]          | default `'{}'`                       |
| `verified`       | boolean         | default `false`                      |
| `created_at`     | timestamptz     | default `now()`                      |

**Relationships**: `owner_id` → `profiles.id` (Many-to-One)

---

## Entity: RfqRequest

| Field        | Type        | Constraints                      |
|--------------|-------------|----------------------------------|
| `id`         | UUID        | PK, default `gen_random_uuid()`  |
| `brand_id`   | UUID        | FK → `profiles.id`, NOT NULL     |
| `factory_id` | UUID        | FK → `factories.id`, nullable    |
| `title`      | text        | NOT NULL                         |
| `description`| text        | NOT NULL                         |
| `quantity`   | integer     | NOT NULL, CHECK > 0              |
| `photo_urls` | text[]      | default `'{}'`                   |
| `created_at` | timestamptz | default `now()`                  |

**Relationships**:
- `brand_id` → `profiles.id` (Many-to-One)
- `factory_id` → `factories.id` (Many-to-One, optional)

> [!NOTE]
> Added `factory_id` (nullable) to link an RFQ to a specific factory when submitted from Factory Profile. Also added `created_at` on factories for future sorting needs.

---

## SQL Migration

```sql
-- ============================================
-- 1. FACTORIES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS factories (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name           TEXT NOT NULL,
  location       TEXT NOT NULL,
  specialization TEXT[] NOT NULL DEFAULT '{}',
  moq            INTEGER NOT NULL DEFAULT 1,
  avg_lead_time  INTEGER NOT NULL,
  rating         NUMERIC(2,1) DEFAULT 0.0 CHECK (rating >= 0 AND rating <= 5),
  owner_id       UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  photos         TEXT[] DEFAULT '{}',
  verified       BOOLEAN DEFAULT FALSE,
  created_at     TIMESTAMPTZ DEFAULT now()
);

-- Index for search/filter queries
CREATE INDEX idx_factories_location ON factories(location);
CREATE INDEX idx_factories_rating ON factories(rating DESC);
CREATE INDEX idx_factories_moq ON factories(moq);
CREATE INDEX idx_factories_owner ON factories(owner_id);

-- RLS
ALTER TABLE factories ENABLE ROW LEVEL SECURITY;

-- Anyone authenticated can read factories
CREATE POLICY "Authenticated users can view factories"
  ON factories FOR SELECT
  TO authenticated
  USING (true);

-- Factory owners can insert their own factory
CREATE POLICY "Factory owners can insert their factory"
  ON factories FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = owner_id);

-- Factory owners can update their own factory
CREATE POLICY "Factory owners can update their factory"
  ON factories FOR UPDATE
  TO authenticated
  USING (auth.uid() = owner_id)
  WITH CHECK (auth.uid() = owner_id);

-- ============================================
-- 2. RFQ_REQUESTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS rfq_requests (
  id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  brand_id    UUID NOT NULL REFERENCES profiles(id) ON DELETE CASCADE,
  factory_id  UUID REFERENCES factories(id) ON DELETE SET NULL,
  title       TEXT NOT NULL,
  description TEXT NOT NULL,
  quantity    INTEGER NOT NULL CHECK (quantity > 0),
  photo_urls  TEXT[] DEFAULT '{}',
  created_at  TIMESTAMPTZ DEFAULT now()
);

-- Index for brand's RFQ history
CREATE INDEX idx_rfq_brand ON rfq_requests(brand_id);
CREATE INDEX idx_rfq_factory ON rfq_requests(factory_id);
CREATE INDEX idx_rfq_created ON rfq_requests(created_at DESC);

-- RLS
ALTER TABLE rfq_requests ENABLE ROW LEVEL SECURITY;

-- Brands can insert their own RFQs
CREATE POLICY "Brands can create RFQs"
  ON rfq_requests FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() = brand_id);

-- Brands can view their own RFQs
CREATE POLICY "Brands can view own RFQs"
  ON rfq_requests FOR SELECT
  TO authenticated
  USING (auth.uid() = brand_id);

-- Factory owners can view RFQs sent to their factory
CREATE POLICY "Factory owners can view received RFQs"
  ON rfq_requests FOR SELECT
  TO authenticated
  USING (
    factory_id IN (
      SELECT id FROM factories WHERE owner_id = auth.uid()
    )
  );

-- ============================================
-- 3. SUPABASE STORAGE BUCKET
-- ============================================
-- Run in Supabase Dashboard → Storage → Create bucket:
--   Name: rfq-photos
--   Public: true
--   File size limit: 5MB
--   Allowed MIME types: image/jpeg, image/png, image/webp
```

---

## Dart Domain Entities

### Factory Entity
```dart
class Factory extends Equatable {
  final String id;
  final String name;
  final String location;
  final List<String> specialization;
  final int moq;
  final int avgLeadTime;
  final double rating;
  final String ownerId;
  final List<String> photos;
  final bool verified;
  final DateTime createdAt;
}
```

### RfqRequest Entity
```dart
class RfqRequest extends Equatable {
  final String id;
  final String brandId;
  final String? factoryId;
  final String title;
  final String description;
  final int quantity;
  final List<String> photoUrls;
  final DateTime createdAt;
}
```
