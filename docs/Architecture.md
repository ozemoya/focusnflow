# Architecture and trust boundaries

Planned layers: Flutter screen -> feature state -> repository -> Firebase SDK / authenticated callable function -> Firestore / Storage. Snapshot listeners return server state through the repository. Firebase Auth supplies UID; typed IDs never establish identity or permission.

Profile/availability is private by default. Group data is member-readable. Membership, accepted schedules and shared timer state are server-authoritative; clients request transitions rather than editing protected aggregates. Firestore rules and Storage rules must deny unauthorized operations independently of visible UI controls.

Implemented locally so far: firestore.rules allows only the owner's direct profile get/create/update with the small schema described in security/README.md; all other document access is denied. Seven emulator checks verify this initial boundary. These rules are not deployed and do not yet implement the planned group/availability policies or a Flutter data connection.

Timers store phase, server anchor, remaining milliseconds, version and last operation identity. Clients interpolate display only; reconnect and lifecycle resume reread server state. Transactions reject stale revisions and make duplicate operation IDs safe. The final implementation must document clock-offset handling rather than assuming device clocks agree.

Firestore indexes are planned for room filters, memberships, group message ordering and sessions by participant/date; exact deployed indexes remain to be verified. Concurrency tests need two accounts/devices and repeatable seeded demo records.

External API decision: use Firebase SDKs and Google authentication; no unrelated commercial data API is needed for the initial scope. Occupancy events are explicitly synthetic. The bounded helper runs on permitted task/availability inputs without sending sensitive academic content to an external AI service.

Before cloud provisioning, review billing prerequisites for Functions and Storage. Do not enable a paid plan or change account permissions as part of planning. Never commit service-account files, passwords, notification tokens, private student data, or signing keys.
