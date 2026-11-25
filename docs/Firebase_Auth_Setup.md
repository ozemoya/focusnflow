# Firebase Auth integration handoff

The SDK adapter is lib/auth/firebase_account_service.dart. It requires an already initialized FirebaseAuth instance; constructing it does not create a project or enable a provider. The app still intentionally uses UnconfiguredAccountService. Do not swap in the adapter until project configuration and session-state integration are ready.

November 25 update: dedicated project `focusnflow-myles-eziz` is active. FlutterFire registered Android package `com.example.focusnflow`, generated lib/firebase_options.dart and android/app/google-services.json, and added the Google Services Gradle plugin. These are client configuration, not service-account credentials. No runtime initialization, Auth provider activation, Firestore database creation or rule deployment was performed by this setup. No billing account was linked. The steps below remain the full handoff; project creation and Android registration are now complete.

Next steps:

1. Create or select a dedicated FocusNFlow Firebase project using the intended account. Review any actual legal/access prompts and obtain billing authorization before paid services are enabled. Never reuse another assignment's production data.
2. Register the Android app with its final application ID; configure FlutterFire, initialize Firebase before SDK access, and enable email/password authentication. Review generated configuration before committing; never commit service-account credentials or signing keys.
3. Inject FirebaseAccountService into the account flow. Drive Profile and permission-sensitive UI from SDK auth-state changes, including restored sessions and sign-out, rather than a one-time route result. Privileged operations must also be enforced by backend rules.
4. Test sign-in and reset with controlled accounts; verify invalid credentials, throttling/network recovery, relaunch persistence and sign-out. Record real emulator/device and console evidence separately from unit-test doubles.
5. Add registration and Google sign-in as separate owned increments, including provider setup and failure/cancellation checks. Profile CRUD must use the tested private schema; the rules still need deliberate deployment and verification.

Current adapter behavior: trim email, preserve password exactly, validate before SDK calls, require a returned UID, map SDK error codes to safe messages and suppress reset's missing-account response. No SDK exception message is copied into a user-facing AccountFailure. The form's existing generic handler handles unexpected exceptions.

Sources: [Firebase password authentication](https://firebase.google.com/docs/auth/flutter/password-auth), [Flutter Auth setup](https://firebase.google.com/docs/auth/flutter/start), and [managing users](https://firebase.google.com/docs/auth/flutter/manage-users).
