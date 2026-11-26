# FocusNFlow

Campus study organizer for Project 2, undergraduate track.

Team: Myles Miller (@ozemoya) and Eziz Bagshiyev (@ezizbagshiyev). Role assignments in the proposal are proposed responsibilities, not completed contributions.

## Current status

Six illustrated study-feature previews with Firebase account integration in progress. Android startup now initializes Firebase and injects the SDK account service; Profile listens to account-state events and exposes sign-out. Provider activation and real-device sign-in/persistence are **not verified yet**. Study scheduling, shared timers, notifications, evaluation and release artifacts remain pending. The app never presents fictional cloud records as real results.

Profile → Account & courses opens the sign-in/reset form when account state is known and signed out. Validation, request locking and error recovery are tested locally. Authentication state comes from SDK events rather than the form's route result. Startup/stream failures leave the account unavailable. Registration, Google sign-in and actual restored-device-session evidence are still pending. See [increment 7](docs/Increment_07_Status.md).

The Firebase foundation now includes owner-only profile rules and seven passing local Firestore emulator tests. These rules have **not been deployed**, and the Flutter profile is not connected to Firestore. See [security setup](security/README.md) and [increment 4 evidence](docs/Increment_04_Status.md).

The official Firebase Auth adapter implements email sign-in, reset, account-state events and sign-out. A debug APK compiles with the integration; a compiled build and SDK-interface stubs do not prove live login or persistence. See [integration handoff](docs/Firebase_Auth_Setup.md).

The dedicated `focusnflow-myles-eziz` Firebase project and Android app are registered, with FlutterFire-generated Android configuration. No billing account was linked by this setup. Provider activation and end-to-end account verification remain pending. Default constructor injection used by preview tests still selects the unconfigured service; Android main selects the real service after successful initialization.

## Proposal and design

- [Proposal draft](docs/Proposal.md)
- [Word proposal draft](docs/FocusNFlow_Proposal_Draft.docx)
- [Six screen wireframes](design/wireframes.svg)
- [Requirements and acceptance criteria](docs/Requirements.md)
- [Architecture and security plan](docs/Architecture.md)
- [Dated task plan](docs/Plan.md)
- [Presentation and ownership plan](docs/Presentation.md)
- [AI transparency log](AI_Usage_Log.md)

Proposal due November 22, 2026 at 11:59 PM; final due December 13, 2026 at 11:59 PM, course local time. The proposal was submitted to Project 02 - Proposal on November 20, 2026 at 1:30 PM course time. The user-supplied signed team statement was included privately in iCollege. Instructor approval has not yet been confirmed.

## Run the preview

Install Flutter, run `flutter pub get`, then `flutter run`. Use `flutter test` and `flutter analyze` for the current checks. Firebase client configuration contains public application identifiers, as described in the [official setup guide](https://firebase.google.com/docs/flutter/setup). No server credentials, passwords, private keys or external API secrets belong in this repository.

## Product direction

Find a study room, coordinate a course group, schedule a conflict-free session, and share a timer across devices. Room occupancy in the initial course demonstration will use explicitly labeled synthetic service events, not claims about live campus sensors. The study helper will compare a bounded availability-aware heuristic against deadline-first ordering using fixed synthetic scenarios. No evaluation outcome is claimed before it is measured.

## Final delivery targets

The final README will link a tested APK, PowerPoint deck, and accessible 20–25 minute video. Both required topic questions FOC-U1 and FOC-U2, plus an owned lifecycle question for each presenter, must have working behavior, attributable history, and reproducible evidence. The final app must integrate Auth, Firestore, Storage, FCM, Cloud Functions, Remote Config, Analytics, and Crashlytics. App Check is optional.

## Visual preview

The six layouts now follow the supplied illustrated reference: cream surfaces, forest-green controls, warm brown focus panels and native vector study scenes. The overview uses actual Flutter renders; it is not an editable Figma design.

![Six-screen preview](design/wireframes.png)

Local preview controls include the room-category chips, focus duration, text-size slider, reminders toggle and bookmark state. They do not create memberships, confirm occupancy, send notifications or start a cloud timer. All 26 Flutter tests pass: two navigation/control, eight account-form, ten SDK-adapter and six session-state checks. Narrow-screen navigation with enlarged text is covered. The overview shows the unconfigured preview state; Profile's email, checking/error text and sign-out control vary with verified account events. Static analysis reports no issues.

