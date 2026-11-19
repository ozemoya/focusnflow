# Requirements and acceptance plan

All rows are planned, not passing test claims. For each implementation record the issue, owner, code commit/PR, test command, actual result, and demo timestamp. Preserve failed-first evidence and corrections.

| ID | Feature | Acceptance and failure evidence |
| --- | --- | --- |
| R01 | Auth and profile | Email/password and Google sign-in, reset, relaunch persistence; invalid credentials shown; another account's edits denied. |
| R02 | Rooms and occupancy | Capacity/amenity filters; absent event is unknown; >5-minute event is stale; reconnect updates freshness without claiming physical sensor coverage. |
| R03 | Course groups | Create/join/leave/remove; nonmember access denied; two competing joins for final place admit only one; duplicate join is idempotent. |
| R04 | Chat | Only members read/write; order by server timestamp and stable ID; failed/offline send visible; duplicate retry does not duplicate message; deleted content handled. |
| R05 | Sessions | Propose/accept/revise, end after start, participants authorized; adjacent slots allowed; overlapping accepted intervals rejected, including concurrent acceptance. |
| R06 | Shared timer | Server state and revision shared across two devices; owner/member policy enforced; pause/resume once per operation; reconnect reconciles anchor and phase; stale commands rejected. |
| R07 | Study helper | Fixed scenarios compared to deadline-first; zero conflicts, all tasks accounted for, infeasible work visible; report actual misses, uncovered minutes, and daily workload spread. |
| F01 | Storage | Image upload/download, progress, type/size validation, owner/group rules, interrupted upload recovery. |
| F02 | FCM | Granted/denied permission, relevant event, deep link, foreground/background handling and duplicate suppression. |
| F03 | Functions | Two Firestore triggers plus callable commands; duplicate delivery does not duplicate notification or state mutation; unauthorized caller denied. |
| F04 | Remote Config | Live fetched toggle changes a visible behavior; fetch failure uses documented default. |
| F05 | Analytics | Custom discovery/join/session events and funnel visible in console; no private text or identifiers in event payload. |
| F06 | Crashlytics | Development-only test crash captured and symbolicated; crash control absent from normal release UI. |
| P01 | Accessibility | Screen labels, keyboard/focus order, text scaling, contrast, loading/empty/error states, reduced-motion behavior. |
| P02 | Release and links | Clean build, tested APK install and core flow; repo/video/deck/APK accessible signed out; no credential leakage. |

Every Must-Solve Challenge gets a decision record comparing two approaches, normal and boundary/failure tests, and permission/concurrency/network recovery where relevant. See proposal for the four initial decisions. Graduate extensions are out of scope for this undergraduate team.
