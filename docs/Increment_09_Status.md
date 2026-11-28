# Increment 9 — Email account registration

November 28, 2026. Scope: [issue 7](https://github.com/ozemoya/focusnflow/issues/7).

Added a separate RegistrationService contract so existing sign-in-only services need not claim registration support. FirebaseAccountService uses the official SDK's createUserWithEmailAndPassword method, trims email, preserves password bytes and refuses invalid local input or a missing SDK identity. Backend duplicate-account, weak-password and network failures map to safe messages. The six-character new-account minimum matches the current provider boundary verified in increment 8; existing-account sign-in still requires only a nonempty password.

The supporting account page offers registration when the injected service supports it. It checks confirmation exactly, locks actions during requests and clears password fields on mode changes. Registration returns the service result to its caller, while Profile continues to derive identity exclusively from account events. The unconfigured preview service still refuses account creation. No privileged data access or roles are granted by client registration.

## Actual checks

`flutter test`: **36 passed**. Ten added checks cover the six-character boundary without changing sign-in rules, invalid registration making no SDK call, safe SDK failures, missing identity, confirmation mismatch, pending locking/retry, service-result handoff, password clearing and explicit unconfigured refusal. These are local widget/unit checks with test doubles, not installed APK or cloud signup evidence.

The first full run exposed two UI-test failures: adding the mode action placed footer feedback beyond the built viewport, and a mode-switch test tapped before scrolling settled. Moved feedback before the form, and waited for scrolling in the registration helpers. The final full suite passed. `flutter analyze`: no issues found. Android device inventory reported no connected devices; no installation or native sign-in/persistence result is claimed. No cloud accounts were created and no provider/billing settings changed during this increment.

The six main layouts, palette and overview remain unchanged. Registration and its confirmation are a supporting account form state rather than a replacement for any of the six required screen roles.

`flutter build apk --debug` succeeded with the registration code. Compilation is not installation or native account-flow evidence. Existing Java/Android SDK-tool warnings did not prevent the build.

## Next step and ownership

Next: installed Android signup/login/sign-out/restart verification using a controlled disposable account, then Google flow and profile CRUD. The previous live REST check remains the only real cloud-account evidence; it must not stand in for the native UI. Foundation remains partial and the December 13 deadline is unchanged. Eziz's write access was reconfirmed; his own implementation or independent verification evidence/commits are still needed. No contribution or learning was invented for him. Instructor approval remains unconfirmed.

Reference: [Firebase Flutter password authentication](https://firebase.google.com/docs/auth/flutter/password-auth).
