# Increment 3 — Local account foundation

November 22, 2026. Scope: [issue 1](https://github.com/ozemoya/focusnflow/issues/1).

Profile's Account & courses action now opens a supporting sign-in/reset form using the existing app theme. All six primary layouts and their reference overview remain unchanged. The form sits behind an injectable AccountService boundary; its production default fails explicitly without sending credentials. No Firebase project, account, session, reset email or cloud result is claimed.

Decisions: trim email input but preserve passwords exactly. Sign-in requires a nonempty password rather than applying new-account password policy to an existing credential. Reset validates email independently of password and uses a neutral inbox message after a successful service response. Disable both request actions while awaiting the service. Dispose controllers and check mounted before asynchronous UI updates. Never display unexpected raw service errors.

## Actual verification

`flutter test`: 10 passed. Eight account checks cover normal test-service success, malformed/oversized email and empty password, invalid inputs making zero service calls, pending-request locking, denied sign-in and retry availability, reset without a password and neutral wording, unconfigured default refusal, unexpected error redaction, and leaving during an outstanding request. These tests use an explicitly named test double and prove client behavior only. The other two tests cover six-screen navigation, room/focus controls and enlarged-text navigation.

The first full run exposed a pre-existing lazy-list test assumption: ensureVisible could not find an unbuilt focus-duration control. Changed that check to scrollUntilVisible; the full suite then passed, including after the final account tests. `flutter analyze`: no issues found. No emulator installation, physical-device, accessibility screen-reader or live Firebase behavior was verified in this increment.

## Next work and collaboration

Next increment: configure a dedicated Firebase project and Android app, then implement the real adapter and restored-session state before enabling authenticated actions. Add registration, Google sign-in and live reset/persistence tests as separate reviewable tasks. Do not substitute the local test double for cloud evidence or enable paid services without approval.

Eziz's write-access invitation was still pending when checked November 22. Proposed work for Eziz: accept the invitation, independently review the form's failure behavior, and implement/verify an owned cloud-authentication task with his own commit and evidence. No contribution is attributed to him by this increment. Proposal approval remains unconfirmed; the November 20 submission milestone is unchanged.
