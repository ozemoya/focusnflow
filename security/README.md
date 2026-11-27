# Local Firestore security checks

Run `npm ci` then `npm test` in this directory with Node and Java 21 installed. The command starts only Firestore on loopback port 8185, uses the fictional `demo-focusnflow` project and shuts the emulator down afterward. It does not deploy rules, provision cloud resources or use a billing account. The suite refuses an unexpected project ID.

The initial `/profiles/{authUid}` schema allows exactly `displayName` (1–80 characters, not all whitespace), `reminders` (boolean), `createdAt` and `updatedAt` (server timestamps). Creation time cannot change. Identity comes from the authenticated UID and document path, never a client-supplied owner field. Only the owner can get, create or update a profile. Listing and deletion are denied; account deletion will need a separately designed cleanup flow. Roles, membership and contact/course/availability fields are not accepted by this initial schema.

Every other document and subcollection is denied. Add narrowly scoped permissions with their own tests as features are implemented. These rules are a foundation, not a complete deployed product policy. The Flutter app does not yet read or write these documents.

The tests use fictional identities and the real local Firestore rules engine. Mock authentication contexts prove rule decisions, not successful Firebase sign-in or production configuration.

References: [Firebase rules testing](https://firebase.google.com/docs/rules/unit-tests) and [field access restrictions](https://firebase.google.com/docs/firestore/security/rules-fields).

## Optional live authentication check

`auth-smoke.mjs` is separate from `npm test`: it contacts the real dedicated Firebase project. In PowerShell, set `$env:FOCUSNFLOW_LIVE_AUTH_TEST='yes'`, then run `node auth-smoke.mjs`. Without that explicit opt-in it refuses to run. It also checks the expected project ID and Android package before making requests.

The check uses a random fictional @example.invalid address and a random password held only in memory. It verifies the five-character password boundary, account creation, invalid/valid login, refresh identity and deletion. A finally block attempts to delete only the newly created account using its own returned token; a final sign-in check confirms the deleted account is denied. It sends no email, stores no credentials and prints only safe check results. If cleanup fails, stop and investigate the private run; do not broadly delete project accounts. Transport failure before the server's creation response is received can leave a disposable account requiring manual investigation.

These are live REST results, not native Flutter installation or restored-session evidence. See [Firebase's Auth REST reference](https://firebase.google.com/docs/reference/rest/auth). Email/password provider activation is declared in firebase.json and was deployed separately with the official CLI's `deploy --only auth` command. No billing or other provider configuration was requested.
