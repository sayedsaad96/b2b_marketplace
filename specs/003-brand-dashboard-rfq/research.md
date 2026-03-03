# Phase 3 Research — Brand Dashboard: Search + RFQ

**Created**: 2026-02-28
**Feature Branch**: `003-brand-dashboard-rfq`

---

## R-001: Image Picker Package

**Decision**: Use `image_picker` for selecting photos from gallery/camera.

**Rationale**: Most popular Flutter image picker (~3500+ pub likes), maintained by the Flutter team, supports both camera and gallery on iOS/Android. Integrates cleanly with Supabase Storage upload via `Uint8List`.

**Alternatives considered**:
- `file_picker` — more general-purpose, but heavier; image_picker is purpose-built.
- `wechat_assets_picker` — feature-rich but overkill for simple photo selection.

---

## R-002: Supabase Storage for Photo Uploads

**Decision**: Use Supabase Storage with a dedicated `rfq-photos` bucket. Upload images as `{userId}/{rfqId}_{timestamp}.jpg`. Store returned public URLs in the `rfq_requests.photo_urls` text array.

**Rationale**: Supabase Storage is already included in `supabase_flutter` — no new dependency. Public URL generation is straightforward. RLS on storage buckets can restrict uploads to authenticated users.

**Alternatives considered**:
- Firebase Storage — would require adding Firebase SDK alongside Supabase, unnecessary complexity.
- Cloudinary — third-party service, adds cost and a new dependency.

---

## R-003: Pagination Strategy

**Decision**: Use Supabase `.range(from, to)` for offset-based pagination in factory search. Page size of 20 items. Trigger next page load when user scrolls within 200px of the bottom.

**Rationale**: Supabase natively supports `.range()` which maps directly to SQL `LIMIT/OFFSET`. For the current scale, offset-based pagination is simple and sufficient. Cursor-based pagination can be adopted later if needed.

**Alternatives considered**:
- Cursor-based pagination — more efficient at large scale, but adds complexity; not needed at current stage.

---

## R-004: Factory Search Filter Architecture

**Decision**: Use Supabase PostgREST query filters combined in a single query builder chain. Filters are: location (exact match or `ilike`), MOQ (`.lte()`), rating (`.gte()`), specialization (`.contains()`). All filters are optional and stackable.

**Rationale**: PostgREST filter chaining translates directly to SQL `WHERE` clauses — no custom SQL needed. Clean, readable Dart code with the Supabase client.

---

## R-005: Photo Gallery Widget

**Decision**: Use the built-in `PageView` widget for the factory profile photo gallery. No additional packages needed.

**Rationale**: `PageView` provides swipeable full-width image display natively. Combined with `CachedNetworkImage` for loading performance. Keeps dependency count minimal.

---

## R-006: New Package Dependencies

**Decision**: Add these packages to `pubspec.yaml`:
- `image_picker: ^1.1.2` — photo selection
- `cached_network_image: ^3.4.1` — image caching and loading
- `uuid: ^4.5.1` — generating UUIDs for RFQ records

**Rationale**: Each package solves a specific need not covered by current dependencies. All are well-maintained and widely used.
