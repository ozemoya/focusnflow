# Increment 7 — Startup and account-session integration

November 26, 2026. Scope: [issue 5](https://github.com/ozemoya/focusnflow/issues/5).

Android main initializes Firebase before SDK access, times out after 15 seconds, and uses a visible unavailable fallback on failure. The real account service is injected into the form. Profile now listens to SDK authentication-state events instead of trusting a route result. It shows checking, signed-out, account email or unavailable states; stream errors and replacement of the session source clear old identity. Sign-out prevents duplicate requests, reports failure and waits for account events to determine signed-out state. No new authenticated study operations are granted by this client display.

All six primary layouts retain the cream/forest/brown design. The static overview remains the unconfigured preview state. Runtime Profile adds account-state text/sign-out; configured startup labels study features as preview. Registration and Google sign-in remain explicitly absent.

## Actual checks and limits

`flutter test`: **26 passed**. Six new session widget checks cover restored identity events, signed-out events, source replacement while waiting, stream failure with stale identity removal, pending/failed sign-out, startup-failure presentation and refusal to turn a route-only result into an authenticated Profile. Three additional SDK-boundary checks cover restored/signed-out event mapping, empty UID rejection and sign-out success/error mapping. Prior account/navigation checks still pass. These use test doubles and prove local behavior, not a real restored device session.

The first analysis reported three brace lints in new code; corrected them. Final `flutter analyze` reports no issues. The Android debug APK compiled with the startup/session integration. No APK installation, successful live login, reset email, real SDK persistence or deployed Firestore result was verified. No provider activation, billing changes or production test-user creation occurred in this increment. The initialization fallback presentation is tested by injection; actual native initialization failure/timeout was not induced.

## Follow-up

The Nov 23–26 cloud-foundation window is only partially complete. Before moving to authenticated room/group operations, finish provider activation, registration/social flow and installed-device account verification, then profile CRUD/rules deployment. Track this carryover rather than marking the phase done. Eziz still has verified repository write access and needs to independently implement or materially verify an owned task with his own evidence/commit. No work is attributed to him by this run. Instructor approval remains unconfirmed.

Reference: [Firebase authentication-state and persistence guidance](https://firebase.google.com/docs/auth/flutter/start).
