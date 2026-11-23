# Increment 4 — Private profile security foundation

November 23, 2026. Scope: [issue 2](https://github.com/ozemoya/focusnflow/issues/2), supporting R01's profile authorization boundary.

Added Firestore rules for owner-only private profile creation, direct read and update, with explicit field/type/length validation and server timestamps. Clients cannot list profiles, inject roles, modify creation time or delete a profile. All other collections and nested documents remain denied until a feature deliberately grants access. The rules use the authenticated UID rather than trusting a client owner field. The initial profile schema and its limits are in security/README.md; course/availability and deletion-cleanup policies remain future work.

## Verified locally

Ran `npm test` in security/ with Node 24.18.1 and Java 21.0.12.1. Firebase CLI launched Firestore on loopback for the fictional demo-focusnflow project; all **7 tests passed** and the emulator shut down successfully. Tested owner create/read/update, anonymous denial, other-user read/create/update/delete denial, enumeration and role injection denial, immutable creation timestamp, display-name bounds 1/80 and invalid 0/81/blank/type cases, missing fields, invalid preferences, forged timestamps and denied unimplemented paths. Expected PERMISSION_DENIED output corresponds to assertFails cases. Dependency versions and lockfile are pinned for reproducibility.

This is real local rules-engine execution with synthetic identities, not live cloud sign-in or deployed-rule evidence. No production project, billing setting or Firebase account permissions were changed. No app/UI code changed; the existing six layouts and overview remain consistent. Flutter tests were not rerun because this increment changes only the separate rules/test toolchain and documentation; their last verified result is recorded in increment 3.

## Collaboration and next step

GitHub now reports write permission for ezizbagshiyev and no pending repository invitation. This verifies access, not any contribution. Eziz should independently review the ownership/privilege tests and take an owned authentication task with his own implementation and evidence. No commits or work were fabricated for him.

Next: dedicated Firebase/Android configuration, real Auth adapter and restored-session state. Cloud legal acceptance, access or paid-service setup must be handled explicitly when encountered. Instructor proposal approval is still unconfirmed. Rooms/groups, scheduling, shared timer, study-helper evaluation, remaining Firebase integrations and final packaging are still pending.
