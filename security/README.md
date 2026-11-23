# Local Firestore security checks

Run `npm ci` then `npm test` in this directory with Node and Java 21 installed. The command starts only Firestore on loopback port 8185, uses the fictional `demo-focusnflow` project and shuts the emulator down afterward. It does not deploy rules, provision cloud resources or use a billing account. The suite refuses an unexpected project ID.

The initial `/profiles/{authUid}` schema allows exactly `displayName` (1–80 characters, not all whitespace), `reminders` (boolean), `createdAt` and `updatedAt` (server timestamps). Creation time cannot change. Identity comes from the authenticated UID and document path, never a client-supplied owner field. Only the owner can get, create or update a profile. Listing and deletion are denied; account deletion will need a separately designed cleanup flow. Roles, membership and contact/course/availability fields are not accepted by this initial schema.

Every other document and subcollection is denied. Add narrowly scoped permissions with their own tests as features are implemented. These rules are a foundation, not a complete deployed product policy. The Flutter app does not yet read or write these documents.

The tests use fictional identities and the real local Firestore rules engine. Mock authentication contexts prove rule decisions, not successful Firebase sign-in or production configuration.

References: [Firebase rules testing](https://firebase.google.com/docs/rules/unit-tests) and [field access restrictions](https://firebase.google.com/docs/firestore/security/rules-fields).
