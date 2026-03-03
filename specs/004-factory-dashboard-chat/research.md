# Research — Factory Dashboard & Chat

**Branch**: `004-factory-dashboard-chat` | **Date**: 2026-02-28

---

## 1. Supabase Realtime for Chat

**Decision**: Use Supabase Realtime PostgreSQL Change Data Capture (CDC) via `.stream()` on the `messages` table.

**Rationale**: Supabase provides a built-in Realtime system that broadcasts INSERT events on any table with Realtime enabled. The `supabase_flutter` SDK exposes `.stream()` which returns a `Stream<List<Map<String, dynamic>>>` — perfect for feeding a Cubit/Bloc without additional packages.

**Alternatives considered**:
- **WebSockets manually**: Too low-level; Supabase already wraps this.
- **Firebase Cloud Messaging**: Not compatible with our Supabase backend.
- **Polling**: Adds latency and server load. Rejected.

---

## 2. Chat Image Storage

**Decision**: Reuse the existing Supabase Storage pattern from Phase 3 (`rfq-photos` bucket). Create a second bucket `chat-images` for separation of concerns.

**Rationale**: Independent bucket allows separate RLS policies and size limits. Chat images may have different retention policies than RFQ photos.

**Alternatives considered**:
- **Single bucket for all images**: Simpler but mixes concerns. Rejected for maintainability.
- **External CDN**: Unnecessary at this scale.

---

## 3. Factory Profile Photo Gallery

**Decision**: Create a `factory-photos` storage bucket. Store photo URLs in the existing `factories.photos` column (text array).

**Rationale**: The `factories` table from Phase 3 already has a `photos` column. We just need the storage bucket and upload logic.

**Alternatives considered**:
- **Separate `factory_photos` table**: Over-engineered for this phase.

---

## 4. Quote Deduplication

**Decision**: Use a UNIQUE constraint on `(rfq_id, factory_id)` in the `rfq_quotes` table to prevent duplicate quotes.

**Rationale**: Database-level constraint is the safest way to prevent duplicates, regardless of client-side bugs or race conditions.

---

## 5. Factory Dashboard Statistics

**Decision**: Compute stats on the fly using aggregate Supabase queries rather than maintaining a separate stats table.

**Rationale**: At early scale, COUNT queries are fast enough. A materialized stats table adds complexity without clear benefit.

**Alternatives considered**:
- **Materialized view / stats table**: Premature optimization. Can be added later if needed.

---

## 6. State Management for Realtime Chat

**Decision**: Use a dedicated `ChatCubit` that subscribes to the Supabase Realtime stream on init and unsubscribes on close. The cubit maintains an in-memory list of messages and appends new ones from the stream.

**Rationale**: Consistent with the existing Cubit pattern. The stream subscription is managed within the cubit lifecycle.

**Alternatives considered**:
- **StreamBuilder in UI directly**: Bypasses state management layer. Rejected for consistency.
- **Riverpod StreamProvider**: Project uses flutter_bloc, not Riverpod.
