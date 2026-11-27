# Increment 8 — Live email provider activation

November 27, 2026. Scope: [issue 6](https://github.com/ozemoya/focusnflow/issues/6).

Declared only emailPassword in firebase.json and used the official Firebase CLI 15.37.0 `deploy --only auth --project focusnflow-myles-eziz` command. The CLI reported successful email/password activation and deployment. Its auth preparation/deployment implementation was inspected to confirm that this configuration provisions the selected provider on the existing Android app. No social provider, billing account or paid-plan change was requested. No legal acceptance or account-access prompt was presented.

## Actual live verification

security/auth-smoke.mjs requires explicit environment opt-in and checks the dedicated project ID and Android package before making any request. It uses a randomly named fictional @example.invalid account and random credentials retained only in memory. No email was sent and no student record was used.

The final live Firebase Auth REST run passed all six checks:

- Five-character signup password rejected by the service.
- Disposable email/password account created.
- Wrong password rejected.
- Correct password returned the same identity.
- Refresh token returned the same identity.
- After deletion, the disposable account could no longer sign in.

The cleanup result was true. Two earlier smoke runs also passed and deleted their own disposable accounts as the boundary/deletion assertions were added. The final version additionally requires an explicit missing/invalid-credentials error after deletion, so a generic service failure cannot count as deletion-denial proof. No test account was intentionally retained. Verified the non-opted-in command refuses to run. Safe output is retained privately under preview-qa; credentials/tokens were not written to that result or printed. Unexpected creation-response transport failure can leave an account without a returned cleanup token; this limitation is documented rather than claimed solved.

These are actual cloud REST responses, not simulated Firebase results, a Flutter SDK platform test or installed APK evidence. No Dart, UI, build or Firestore rule source changed, so the prior 26 Flutter tests, clean analysis, debug compilation and seven emulator rule checks were not repeated. The six-screen design remains unchanged.

## Remaining work

Next: registration UI and installed-device sign-in/sign-out/restart verification, then Google provider/flow and profile integration. Real reset delivery is still unverified. The broader cloud-foundation phase remains partial. Eziz's repository write access is confirmed; he needs an independently owned implementation or verification task with his own commit/evidence. No work, learning or commits were invented for him. Instructor approval remains unconfirmed.

Sources: the installed official CLI auth deployment implementation; [Firebase Auth REST reference](https://firebase.google.com/docs/reference/rest/auth); [Identity Toolkit config API](https://cloud.google.com/identity-platform/docs/reference/rest/v2/projects/updateConfig).
