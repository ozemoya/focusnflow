# FocusNFlow

Campus study organizer for Project 2, undergraduate track.

Team: Myles Miller (@ozemoya) and Eziz Bagshiyev (@ezizbagshiyev). Role assignments in the proposal are proposed responsibilities, not completed contributions.

## Current status

An explicitly labeled six-screen Flutter design preview, now with a supporting account form and a tested account-service boundary. Firebase services, study scheduling, shared timers, notifications, evaluation, and release artifacts are **not implemented or verified yet**. The prototype never presents fictional cloud records as real results.

Profile → Account & courses opens the sign-in/reset form. Local validation, request locking and error recovery work; the default service explicitly refuses requests because Firebase is not configured. No credentials leave the app and no account/session is created. Google sign-in, registration, persistent session gating and a live Firebase adapter are still pending. See [increment 3 evidence](docs/Increment_03_Status.md).

The Firebase foundation now includes owner-only profile rules and seven passing local Firestore emulator tests. These rules have **not been deployed**, and the Flutter profile is not connected to Firestore. See [security setup](security/README.md) and [increment 4 evidence](docs/Increment_04_Status.md).

An official Firebase Auth SDK adapter now implements email sign-in and password reset, with seven adapter unit tests. It is not wired into the preview until Firebase initialization and session-state handling are ready. A debug APK compiled successfully with the new SDK dependencies; live sign-in, installation and persistence are not yet verified. See [integration handoff](docs/Firebase_Auth_Setup.md) and [increment 5](docs/Increment_05_Status.md).

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

Install Flutter, run `flutter pub get`, then `flutter run`. Use `flutter test` and `flutter analyze` for the current navigation checks. There are no credentials, Firebase project keys, or external API secrets in this starter.

## Product direction

Find a study room, coordinate a course group, schedule a conflict-free session, and share a timer across devices. Room occupancy in the initial course demonstration will use explicitly labeled synthetic service events, not claims about live campus sensors. The study helper will compare a bounded availability-aware heuristic against deadline-first ordering using fixed synthetic scenarios. No evaluation outcome is claimed before it is measured.

## Final delivery targets

The final README will link a tested APK, PowerPoint deck, and accessible 20–25 minute video. Both required topic questions FOC-U1 and FOC-U2, plus an owned lifecycle question for each presenter, must have working behavior, attributable history, and reproducible evidence. The final app must integrate Auth, Firestore, Storage, FCM, Cloud Functions, Remote Config, Analytics, and Crashlytics. App Check is optional.

## Visual preview

The six layouts now follow the supplied illustrated reference: cream surfaces, forest-green controls, warm brown focus panels and native vector study scenes. The overview uses actual Flutter renders; it is not an editable Figma design.

![Six-screen preview](design/wireframes.png)

Local preview controls include the room-category chips, focus duration, text-size slider, reminders toggle and bookmark state. They do not create memberships, confirm occupancy, send notifications or start a cloud timer. All 17 Flutter tests pass, including two navigation/control checks, eight account-form checks and seven SDK-adapter checks. Narrow-screen navigation with enlarged text is covered. Static analysis reports no issues.

