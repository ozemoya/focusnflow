# Increment 5 — Firebase Auth SDK adapter

November 24, 2026. Scope: [issue 3](https://github.com/ozemoya/focusnflow/issues/3).

Added firebase_core 5.2.0 and firebase_auth 7.1.0, recorded in pubspec and lockfile. FirebaseAccountService calls the official SDK's email/password sign-in and reset methods. It validates before making a request, preserves password whitespace, maps service identity into Account and refuses a missing/empty UID. Credential and disabled-account failures share neutral wording. Reset suppresses a missing-account result; network errors still fail rather than pretending a link was sent. User-facing failures use code-based messages instead of raw SDK diagnostics.

The adapter takes an initialized FirebaseAuth instance; it does not access the singleton or create a cloud project itself. The preview intentionally still uses UnconfiguredAccountService. No live authentication, reset email, registration, social sign-in, restored session or Firestore connection is claimed. All six primary layouts and wireframes remain unchanged.

## Actual checks

- `flutter test`: 17 passed, including seven new SDK-interface unit checks for success/forwarded input, invalid input with zero SDK calls, missing identity, credential denials, safe failure categories, private reset behavior and reset network failure. Explicit StubAuth/StubCredential/StubUser objects are test doubles, not cloud or plugin-platform execution evidence.
- First `flutter analyze` found two test-style lints and unrelated Dart templates inside the installed Firebase CLI's node_modules. Added braces and excluded only security/node_modules from Flutter analysis. The application/test source remains analyzed.
- Final `flutter analyze`: no issues found.
- `flutter build apk --debug`: succeeded, producing build/app/outputs/flutter-apk/app-debug.apk with the new native dependencies. This verifies compilation, not APK installation or a real account flow. Existing Android SDK-tool metadata warnings did not prevent the build. Release signing remains future work.

## Next work and ownership

Follow Firebase_Auth_Setup.md for project/Android configuration, initialization, real service injection and auth-state-driven Profile/session handling. Add registration, Google sign-in and device/network/persistence evidence separately. Do not enable paid services without authorization. Instructor approval remains unconfirmed.

GitHub still confirms Eziz has write permission. He needs to implement or independently verify an owned task and commit his own evidence; access alone is not a contribution. This increment does not attribute work or learning to him.
