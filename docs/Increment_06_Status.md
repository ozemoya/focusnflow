# Increment 6 — Dedicated Firebase Android configuration

November 25, 2026. Scope: [issue 4](https://github.com/ozemoya/focusnflow/issues/4).

The authenticated official Firebase CLI created the dedicated FocusNFlow project `focusnflow-myles-eziz` and a subsequent project listing confirmed ACTIVE state. No billing account was linked, paid plan enabled or other assignment's project modified. No legal-acceptance or access-change prompt was presented. FlutterFire registered Android package com.example.focusnflow and app ID 1:824692412416:android:7480618f32f01b840788e5, generated the Android/Dart client configuration and added the Google Services Gradle plugin. Client configuration contains non-secret identifiers; no account tokens or server credentials are committed.

The first FlutterFire attempt could not find the newly created project. A fresh Firebase CLI listing confirmed it active; retrying FlutterFire then completed successfully. This was a setup discovery failure, not evidence of an authentication failure in the app.

The six primary layouts and wireframes are unchanged. The app still uses the explicit unconfigured account service. This increment does not claim a working sign-in, activated provider, restored session, Firestore database, deployed rules, installed release or instructor approval.

## Verification and follow-up

Confirmed that the generated google-services.json project ID, registered Android app ID and application package match the intended dedicated project, without printing client keys. Rechecked the separate demo-project rules suite after FlutterFire merged firebase.json to ensure local security tests remain isolated.

`npm test` in security/: all seven local rule checks passed and the emulator shut down. `flutter analyze`: no issues found. The prior 17 Flutter unit/widget checks remain the last recorded test-suite result; no widget behavior changed in this configuration increment.

`flutter build apk --debug`: succeeded with the generated Google Services configuration and Gradle plugin. This is compilation evidence only; the APK was not installed or used to sign in during this increment. Existing Java native-access and Android SDK metadata warnings did not prevent the build.

Next increment: initialize Firebase with an explicit failure state, drive the account UI from restored auth state and inject the real service. Activate/verify email authentication, then add registration and Google sign-in as separate reviewable work. Installed-device and real-account persistence evidence remain required. Future paid Functions/Storage setup requires authorization before enabling billing.

Eziz's repository write permission was reconfirmed. He needs to independently implement or verify an owned authentication task with his own commit and evidence. No contribution is attributed merely from access.
