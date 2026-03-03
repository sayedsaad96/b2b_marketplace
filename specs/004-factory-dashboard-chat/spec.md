# Feature Specification: Factory Dashboard & Chat System

**Feature Branch**: `004-factory-dashboard-chat`  
**Created**: 2026-02-28  
**Status**: Draft  
**Input**: User description: "Phase 4 — Factory Dashboard with quote submission, profile management, order tracking, and a real-time chat system between brands and factories per RFQ."

## User Scenarios & Testing *(mandatory)*

### User Story 1 — Factory Reviews & Responds to RFQs (Priority: P1)

A factory owner logs in and lands on the **Factory Dashboard Home**, which surfaces key statistics (new RFQs, profile views, total accepted quotes) and a list of the most recent RFQs received. From the dashboard or the dedicated **RFQ Inbox** screen, they tap on an RFQ to see its full details (brand name, product title, quantity, description, attached photos) and tap **Submit Quote**. A form appears where they enter the proposed **price**, **lead time** (in days), and optional **notes**. On submission the quote is recorded and the RFQ card reflects the new status.

**Why this priority**: Quoting is the primary revenue action for factories; without it the marketplace has no supply-side engagement.

**Independent Test**: A factory user can open the app, view received RFQs, submit a quote, and see it reflected in the inbox — without any other feature being present.

**Acceptance Scenarios**:

1. **Given** a factory user with pending RFQs, **When** they open the RFQ Inbox, **Then** they see a list of all RFQs addressed to them, each showing brand name, title, quantity, and submission date.
2. **Given** a factory user viewing an RFQ, **When** they tap "Submit Quote" and fill in price, lead time, and notes, **Then** a quote record is created with status "pending" and the user sees a success confirmation.
3. **Given** a factory user who already submitted a quote for an RFQ, **When** they view that RFQ again, **Then** they see their submitted quote details instead of the submission form.

---

### User Story 2 — Factory Dashboard Home with Statistics (Priority: P1)

A factory owner sees an at-a-glance dashboard upon login. The dashboard displays **stat cards** for the number of new (un-quoted) RFQs, total profile views, and the count of accepted quotes. Below the stats is a chronological list of recent RFQs with the brand name, title, and relative time ("2 hours ago").

**Why this priority**: The dashboard is the landing experience for every factory session and directly drives engagement with the inbox.

**Independent Test**: A factory user can log in and see accurate statistics and recent RFQ list on the home screen.

**Acceptance Scenarios**:

1. **Given** a factory user with 5 new RFQs and 3 accepted quotes, **When** they open the Dashboard Home, **Then** stat cards display "5 New RFQs", profile view count, and "3 Accepted Quotes".
2. **Given** no RFQs exist for this factory, **When** they open the Dashboard Home, **Then** all stat cards show zero and the recent RFQ list shows an empty state message.

---

### User Story 3 — Factory Profile Management (Priority: P2)

A factory owner navigates to **My Profile** (accessible from a bottom navigation bar) to edit their factory details: name, location, specializations, minimum order quantity (MOQ), and typical lead time. They can also upload or remove photos to a gallery showcasing their facility and products. Tapping **Save** persists all changes.

**Why this priority**: An accurate profile increases trust and conversion on the brand side, but the marketplace can function with default profile data initially.

**Independent Test**: A factory user can open their profile, edit fields, upload images, save, and verify changes persist on reload.

**Acceptance Scenarios**:

1. **Given** a factory user on the My Profile screen, **When** they update their factory name and tap "Save", **Then** the updated name is persisted and visible upon reloading the profile.
2. **Given** a factory user on the My Profile screen, **When** they upload 3 photos, **Then** the photos appear in the gallery and are stored remotely.
3. **Given** a factory user on the My Profile screen, **When** they remove a previously uploaded photo and tap "Save", **Then** the photo is removed from the gallery and from remote storage.

---

### User Story 4 — Real-Time Chat per RFQ (Priority: P2)

Both brand and factory users can open a **chat screen** linked to a specific RFQ. Messages appear in real time without manual refresh. Users can send text messages and attach images. The chat is ordered chronologically with the newest message at the bottom and auto-scrolls on new messages.

**Why this priority**: Chat drives negotiation and relationship-building, but the core quote workflow (P1) can function without it via the notes field.

**Independent Test**: A brand user and a factory user can both open the chat for the same RFQ and exchange text and image messages that appear instantly on both sides.

**Acceptance Scenarios**:

1. **Given** a brand user and a factory user both viewing the chat for the same RFQ, **When** the brand sends a text message, **Then** the factory user sees it appear within 2 seconds without refreshing.
2. **Given** a user in the chat screen, **When** they attach and send an image, **Then** the image is uploaded, stored, and displayed inline in the conversation for both parties.
3. **Given** a chat with 50+ messages, **When** the user opens the chat, **Then** messages are loaded in reverse-chronological order with the most recent visible first and older messages loadable by scrolling up.

---

### User Story 5 — Active Orders Tracking (Priority: P3)

A factory user navigates to an **Active Orders** screen that lists all quotes they have submitted which were accepted by the brand. Each card shows the RFQ title, brand name, agreed price, lead time, and current status.

**Why this priority**: Order tracking adds operational value but depends on the quote acceptance flow being in place first.

**Independent Test**: A factory user with accepted quotes can see them listed on the Active Orders screen with correct details.

**Acceptance Scenarios**:

1. **Given** a factory user with 3 accepted quotes, **When** they open Active Orders, **Then** they see 3 cards each showing RFQ title, brand name, price, lead time, and status.
2. **Given** a factory user with no accepted quotes, **When** they open Active Orders, **Then** they see an empty state message.

---

### Edge Cases

- What happens when a factory tries to submit a quote for an RFQ that has already been cancelled by the brand?
- What happens when a user sends a message with only whitespace or an empty string?
- How does the system handle image upload failure mid-chat (e.g., network loss)?
- What happens when two factories submit quotes for the same RFQ simultaneously?
- How does the dashboard behave when the factory profile has never been completed?

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST display a Factory Dashboard Home screen with stat cards (new RFQ count, profile views, accepted quote count) and a list of recent RFQs.
- **FR-002**: System MUST provide an RFQ Inbox screen listing all RFQs targeted at the logged-in factory, showing brand name, title, quantity, and a "Submit Quote" action.
- **FR-003**: System MUST allow a factory user to submit a quote for an RFQ by providing price, lead time (in days), and optional notes.
- **FR-004**: System MUST prevent a factory from submitting more than one quote per RFQ.
- **FR-005**: System MUST provide a My Profile screen where a factory user can edit their name, location, specializations, MOQ, and lead time.
- **FR-006**: System MUST allow a factory user to upload multiple photos to their profile gallery and persist them in remote storage.
- **FR-007**: System MUST allow a factory user to remove photos from their profile gallery, deleting them from remote storage.
- **FR-008**: System MUST provide a real-time chat screen per RFQ accessible to both the brand and factory participants.
- **FR-009**: Chat messages MUST appear in real time (within 2 seconds) for both participants without manual refresh.
- **FR-010**: System MUST support sending text messages and image attachments in chat.
- **FR-011**: System MUST store all chat messages persistently and load them chronologically when the chat is reopened.
- **FR-012**: System MUST provide an Active Orders screen listing all accepted quotes for the logged-in factory.
- **FR-013**: System MUST validate that price is a positive number and lead time is a positive integer before accepting a quote submission.
- **FR-014**: System MUST show a loading indicator during data fetches and quote/message submissions.
- **FR-015**: System MUST display user-friendly error messages when network operations fail.

### Key Entities

- **RFQ Quote**: A factory's response to an RFQ, containing the proposed price, lead time, notes, and a status (pending / accepted / rejected). Each quote is linked to exactly one RFQ and one factory.
- **Message**: A single chat message within an RFQ conversation, containing text content and/or an image, linked to the RFQ and the sender. Messages are ordered by creation time.
- **Factory Profile**: The factory's public-facing information including name, location, specializations, MOQ, lead time, and a gallery of photos.

## Assumptions

- Factory users are already authenticated and their role is known from the existing auth system (Phase 2).
- The `rfq_requests` table from Phase 3 already exists and contains RFQs submitted by brand users.
- The `factories` table from Phase 3 already exists with basic factory profile fields.
- Profile view counting is tracked via a simple counter or log; the exact mechanism is an implementation detail.
- A quote's status transitions from "pending" to "accepted" or "rejected" are triggered by the brand user (this will be handled as part of the brand-side quote review, which may be a future phase or part of this implementation).
- The chat system uses a persistent connection model for real-time message delivery.
- Image uploads in chat follow the same storage patterns as RFQ photo uploads from Phase 3.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: Factory users can view their dashboard statistics and recent RFQs within 2 seconds of logging in.
- **SC-002**: Factory users can submit a complete quote (price + lead time + notes) in under 1 minute from opening the RFQ.
- **SC-003**: Chat messages are delivered to both participants within 2 seconds of being sent.
- **SC-004**: Factory users can update their profile (including photo uploads) and see changes persisted immediately upon saving.
- **SC-005**: 95% of factory users can complete the quote submission flow on their first attempt without errors.
- **SC-006**: The Active Orders screen accurately reflects all accepted quotes for the factory within 3 seconds of opening.
- **SC-007**: Chat supports image attachments up to 5 MB without degradation in send/receive latency.
