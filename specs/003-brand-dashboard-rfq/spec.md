# Feature Specification: Brand Dashboard — Search + RFQ

**Feature Branch**: `003-brand-dashboard-rfq`
**Created**: 2026-02-28
**Status**: Draft
**Input**: User description: "Phase 3 — Brand Dashboard: factory search, factory profiles, RFQ submission, and RFQ history"

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Brand Discovers Factories from Home (Priority: P1)

A brand user opens the app and lands on the Brand Home screen. They see a search bar at the top, a row of tappable category chips (e.g. T-shirts, Jackets, Dresses), and a horizontally scrollable carousel of top-rated factories. Tapping a category chip or using the search bar navigates them to the Factory Search screen with the relevant filter pre-applied.

**Why this priority**: The home screen is the brand user's entry point to the entire marketplace. Without it, brands have no way to begin exploring suppliers.

**Independent Test**: Can be tested by logging in as a Brand user, verifying the home screen loads with search bar, category chips, and a top-factories carousel with data.

**Acceptance Scenarios**:

1. **Given** an authenticated Brand user, **When** they open the app, **Then** they see the Brand Home screen with a search bar, category chips, and a "Top Factories" carousel.
2. **Given** a Brand user on the Home screen, **When** they tap a category chip (e.g. "T-shirts"), **Then** they are navigated to the Factory Search screen with the specialization filter pre-set to "T-shirts".
3. **Given** a Brand user on the Home screen, **When** they type a query in the search bar and submit, **Then** they are navigated to the Factory Search screen with the search query applied.
4. **Given** a Brand user on the Home screen, **When** they tap on a factory card in the Top Factories carousel, **Then** they are navigated to that factory's profile screen.
5. **Given** no factories exist in the database, **When** the Brand Home screen loads, **Then** the carousel area displays an empty-state message (e.g. "No top factories yet").

---

### User Story 2 — Brand Searches and Filters Factories (Priority: P1)

A brand user navigates to the Factory Search screen and sees a scrollable list of factory cards. Each card shows the factory's name, star rating, minimum order quantity (MOQ), and average lead time. The user can apply filters (location, minimum MOQ, minimum rating) to narrow the results. Results update in real-time as filters change.

**Why this priority**: Search is the core discovery mechanism — brands need to find qualifying manufacturers efficiently.

**Independent Test**: Can be tested by navigating to Factory Search, applying various filters, and verifying the factory list updates correctly.

**Acceptance Scenarios**:

1. **Given** a Brand user on the Factory Search screen, **When** the screen loads, **Then** a list of factory cards is displayed, each showing name, rating, MOQ, and average lead time.
2. **Given** a Brand user on the Factory Search screen, **When** they apply a location filter (e.g. "China"), **Then** only factories with a matching location are shown.
3. **Given** a Brand user on the Factory Search screen, **When** they set a maximum MOQ filter (e.g. ≤ 500), **Then** only factories with MOQ at or below the threshold are shown.
4. **Given** a Brand user on the Factory Search screen, **When** they set a minimum rating filter (e.g. ≥ 4.0), **Then** only factories meeting or exceeding that rating are shown.
5. **Given** a Brand user on the Factory Search screen, **When** they combine multiple filters, **Then** results reflect all active filters simultaneously.
6. **Given** filters that match no factories, **When** the search completes, **Then** an empty-state message is displayed (e.g. "No factories match your filters").
7. **Given** a large number of results, **When** the user scrolls to the bottom of the list, **Then** the next page of results loads automatically (pagination).
8. **Given** a Brand user on the Factory Search screen, **When** they tap on a factory card, **Then** they are navigated to that factory's profile screen.

---

### User Story 3 — Brand Views a Factory Profile (Priority: P1)

A brand user taps on a factory card (from Search or Home carousel) and is navigated to the Factory Profile screen. They see full details: factory name, location, specialization tags, MOQ, average lead time, star rating, a verification badge (if verified), and a photo gallery. A prominent "Request Quote" button is available.

**Why this priority**: Factory profiles are essential for brands to evaluate manufacturers before committing to a quote request.

**Independent Test**: Can be tested by tapping any factory card and verifying all profile fields, the photo gallery, and the "Request Quote" button render correctly.

**Acceptance Scenarios**:

1. **Given** a Brand user tapping a factory card, **When** the Factory Profile screen loads, **Then** it displays: factory name, location, specialization tags, MOQ, average lead time, and star rating.
2. **Given** a factory with photos, **When** the profile loads, **Then** a scrollable photo gallery is displayed.
3. **Given** a factory with no photos, **When** the profile loads, **Then** a placeholder image or "No photos available" message is shown.
4. **Given** a factory with `verified = true`, **When** the profile loads, **Then** a verified badge is displayed alongside the factory name.
5. **Given** a Brand user viewing a factory profile, **When** they tap the "Request Quote" button, **Then** they are navigated to the RFQ Form screen with the factory pre-linked.
6. **Given** a factory whose data fails to load (network error), **When** the profile screen opens, **Then** a retry-friendly error message is displayed.

---

### User Story 4 — Brand Submits an RFQ (Priority: P1)

A brand user navigates to the RFQ Form screen (via "Request Quote" from a Factory Profile). The form has fields for title, description, desired quantity, and optional photo uploads. Upon submitting, an RFQ record is created in the database and the user is shown a success confirmation.

**Why this priority**: RFQ submission is the core transaction initiation for the platform — it connects brand demand to factory supply.

**Independent Test**: Can be tested by filling in the RFQ form with valid data, submitting it, and verifying the record appears in the database and in the user's RFQ history.

**Acceptance Scenarios**:

1. **Given** a Brand user on the RFQ Form screen, **When** the screen loads, **Then** they see input fields for title, description, quantity, and a photo upload area.
2. **Given** a Brand user on the RFQ Form screen, **When** they fill in all required fields (title, description, quantity) and tap Submit, **Then** the RFQ record is saved and a success message is shown.
3. **Given** a Brand user on the RFQ Form screen, **When** they submit without filling in required fields, **Then** inline validation errors are displayed (e.g. "Title is required").
4. **Given** a Brand user on the RFQ Form screen, **When** they add one or more photos, **Then** the photos are uploaded and their URLs are stored with the RFQ.
5. **Given** a Brand user on the RFQ Form screen, **When** they submit with no photos, **Then** the RFQ is submitted successfully (photos are optional).
6. **Given** a successful RFQ submission, **When** the user is redirected, **Then** the new RFQ appears in the user's RFQ history list.
7. **Given** a network error during submission, **When** the submission fails, **Then** a user-friendly error is shown and the form data is preserved so the user can retry.

---

### User Story 5 — Brand Views Their RFQ History (Priority: P2)

A brand user navigates to the My RFQs screen and sees a chronological list of all RFQ requests they have submitted. Each item shows the title, quantity, and submission date.

**Why this priority**: Brands need visibility into their submitted requests for tracking and follow-up. It is not as critical as the submission flow itself.

**Independent Test**: Can be tested by submitting one or more RFQs and navigating to My RFQs to verify all submissions appear correctly.

**Acceptance Scenarios**:

1. **Given** a Brand user who has submitted RFQs, **When** they navigate to My RFQs, **Then** they see a list of all their submitted RFQs ordered by most recent first.
2. **Given** a Brand user who has not submitted any RFQs, **When** they navigate to My RFQs, **Then** an empty-state message is shown (e.g. "You haven't submitted any RFQs yet").
3. **Given** a Brand user viewing My RFQs, **When** they see an RFQ item, **Then** it shows the title, quantity requested, and creation date.

---

### Edge Cases

- What happens if a brand user tries to access factory-only routes? → Redirect to Brand Home with an appropriate message.
- What happens if the user uploads a photo that exceeds the maximum file size? → Display a validation error before submission (e.g. "Image must be under 5 MB").
- What happens when network is lost while the factory list is loading? → Show a "no connection" error with a Retry button.
- What happens if a factory is deleted after a brand has submitted an RFQ to it? → RFQ remains valid and visible in the brand's history; the factory reference may show "Factory no longer available".
- What happens if the user submits the RFQ form by tapping Submit rapidly multiple times? → Disable the Submit button after first tap to prevent duplicate submissions.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a Brand Home screen with a search bar, category chips, and a top-factories carousel after a Brand user logs in.
- **FR-002**: System MUST navigate to the Factory Search screen with the selected category pre-applied when a category chip is tapped.
- **FR-003**: System MUST display a searchable, filterable list of factory cards on the Factory Search screen, each showing name, rating, MOQ, and lead time.
- **FR-004**: System MUST support filtering factories by location, maximum MOQ, and minimum rating—applied individually or in combination.
- **FR-005**: System MUST support paginated loading of factory results (lazy loading / infinite scroll).
- **FR-006**: System MUST display a Factory Profile screen with full details: name, location, specialization tags, MOQ, lead time, rating, verified badge, and photo gallery.
- **FR-007**: System MUST provide a "Request Quote" button on the Factory Profile screen that navigates to the RFQ Form.
- **FR-008**: System MUST provide an RFQ Form with fields for title, description, quantity, and optional photo uploads.
- **FR-009**: System MUST validate that title, description, and quantity are non-empty before allowing submission.
- **FR-010**: System MUST create an `rfq_requests` record in the database upon form submission, linked to the authenticated brand user.
- **FR-011**: System MUST display a My RFQs screen listing all RFQ requests submitted by the current brand user, ordered by most recent first.
- **FR-012**: System MUST display clear, user-friendly error messages for all error scenarios (network failures, validation errors, empty states).
- **FR-013**: System MUST show empty-state UI when no factories match filters or when the user has no submitted RFQs.
- **FR-014**: System MUST prevent duplicate RFQ submissions by disabling the Submit button after the first tap.

### Key Entities

- **Factory**: Represents a manufacturing facility — includes name, geographic location, product specialization categories, minimum order quantity, average production lead time (days), star rating, owner reference, photo gallery, and verification status.
- **RFQ Request**: Represents a brand's request for a quote — includes a title, detailed description, desired quantity, optional reference photos, and creation timestamp. Linked to the brand user who submitted it.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Brand users can navigate from Home to a factory profile in under 3 taps.
- **SC-002**: Factory search results load within 2 seconds under normal network conditions.
- **SC-003**: Applying a filter updates the factory list within 1 second.
- **SC-004**: 100% of validation errors on the RFQ form display user-readable inline messages.
- **SC-005**: Brand users can complete the full flow (Home → Search → Factory Profile → RFQ Form → Submit) in under 2 minutes.
- **SC-006**: All submitted RFQs appear in the My RFQs list within 5 seconds of submission.
- **SC-007**: Empty states are shown for 100% of scenarios where data is absent (no factories, no RFQs, no photos).

## Assumptions

- The `factories` and `rfq_requests` Supabase tables will be created as part of this phase. Their schemas are defined by the user (see Input above).
- Supabase Row-Level Security (RLS) policies will be created for both tables: insert/select for authenticated users; factories owned by factory users, RFQs owned by brand users.
- The Brand Home screen replaces the existing placeholder Brand Home screen from Phase 2.
- Photo uploads will use Supabase Storage; image URLs are stored as text arrays in the respective tables.
- Factory data (seed data for development) will be manually inserted or seeded via SQL.
- The category chips on the Brand Home screen correspond to values in the `specialization` array field of the `factories` table. Initial categories: T-shirts, Jackets, Dresses, Denim, Activewear, Accessories.
- The top-factories carousel on the Brand Home screen displays factories sorted by highest rating.
- The "verified" badge is a display-only indicator based on the boolean field; the admin verification workflow itself is out of scope for this phase.
- The RFQ Form does not pre-select or require a specific factory — it records the brand's request generically. If navigated from a factory profile, the factory ID is captured for reference but is optional.
- Navigation follows the pattern: BrandHome → FactorySearch → FactoryProfile → RfqForm → MyRfq.
- State management uses the BLoC/Cubit pattern consistent with Phase 2 (FactorySearchCubit, RfqCubit).
- The existing auth, routing, and design system from Phase 2 is intact and will be extended.
