# AI usage log

## November 23 2026 — Profile rules and emulator checks

Codex assisted with issue 2: the initial private-profile schema, deny-by-default Firestore rules and seven emulator tests. Consulted Firebase's official rules-unit-testing and field-access documentation, linked in security/README.md. Accepted: UID-based ownership, allowlisted fields, immutable creation time and server-generated timestamps. Rejected: trusting client roles/owner fields or treating emulator authentication contexts as live sign-in proof.

Actual result: `npm test` ran the local Firestore rules engine with a demo project and passed all seven checks. No cloud resources were provisioned, deployed or billed, and no UI changes were made. Eziz now has verified repository write access; no implementation, learning or review is attributed to him without his own evidence.

## November 22 2026 — Account form foundation

Codex assisted with issue 1: the account-service interface, supporting sign-in/reset form, local input validation, asynchronous request/error handling and eight account tests. Accepted: separating local form behavior from the eventual Firebase adapter, preserving passwords exactly, neutral reset wording and mounted checks. Rejected: pretending that a successful test double proves cloud authentication, or allowing the unconfigured app to create a fake session. The existing six-screen visual direction is preserved.

Actual checks: the first full suite found an existing lazy-list test failure; scrolling until the duration control is built fixed that test assumption. Final `flutter test` passed all 10 checks and `flutter analyze` found no issues. Firebase, installed-device authentication, Google sign-in and persisted sessions remain unverified. Neither student's learning nor Eziz's work is inferred from these automated checks.

## November 19 2026 — Codex

User direction: choose an approved Project 2 topic and start a new project, with Eziz Bagshiyev as teammate. Sources: official Project 2 overview, team instructions, presentation questions, and additional requirements.

Generated material: proposed FocusNFlow scope, six-screen preview, wireframe draft, proposal draft, architecture, test plan, and tentative ownership schedule. These are AI-assisted drafts for student review; they are not claimed as original unaided student work or as evidence of either member's completed implementation.

Accepted in this preparation: the approved topic and undergraduate scope. Changed from a generic study timer: added room freshness, membership enforcement, conflict handling, server-authoritative shared timing, required Firebase services, baseline evaluation, and individual evidence requirements. Rejected: treating a local countdown or static occupancy screen as proof of a synchronized cloud feature.

Verification: official requirement text was read live. Prototype navigation checks and static analysis are recorded in the preparation status. Firebase behavior and AI evaluation remain unverified. No student learning outcome, teammate contribution, peer test, metric, or signed statement has been invented.

Student follow-up: both members must review the plan, understand their assigned code, independently implement or materially verify owned tasks, and add what they accepted, changed, tested, and learned as development proceeds.

## November 20 2026 — Reference-driven UI increment

User supplied a three-screen illustrated reading-app reference and requested that FocusNFlow keep its study-organizer features while adopting that visual direction. Codex assisted with the six screen layouts, cream/forest/terracotta palette, native vector illustrations, navigation, and local-only preview controls. No illustration or screenshot is presented as a real campus occupancy report or a connected Firebase feature.

Changed after review: replaced the generic card list with distinct Today, Rooms, Groups, Plan, Focus, and Profile layouts; kept unavailable/unknown states explicit; captured actual Flutter-rendered screen images rather than fabricated app results. The SVG is now a visual overview containing the rendered screens, not a claim of fully editable Figma layers.

Verification: static analysis was clean before adding the updated tests; both widget checks passed after the restyle. They cover all six destinations, room filter state, duration selection without starting a shared session, and 320-pixel navigation at enlarged text. Each of the six rendered screens was visually inspected. No Android release-build, cloud, or AI-evaluation result is claimed by this UI increment.
