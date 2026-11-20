# FocusNFlow proposal draft

Myles Miller (@ozemoya) and Eziz Bagshiyev (@ezizbagshiyev), undergraduate track. Prepared November 19, 2026. Draft for team review; responsibilities below are proposed, not completed contributions.

## Problem and audience

Campus students need to find an appropriate study room, coordinate classmates, and start a shared focus session without relying on scattered messages. FocusNFlow will combine room discovery, course groups, a conflict-aware session planner, and a synchronized timer. It is an approved Project 2 topic. The first demonstration will use clearly identified synthetic room-occupancy events; it will not claim to measure actual campus rooms.

## User stories and success criteria

1. As a student, I can filter rooms by capacity and amenities and see when occupancy was last updated. A room with no event is unknown; data older than five minutes is stale. Neither state is displayed as available.
2. As a group member, I can propose a study session that fits the participating members' shared availability. Two overlapping accepted sessions cannot be confirmed for the same participant. Nonmembers cannot read group messages or control its timer.
3. As a student, I can compare a suggested study sequence with deadline-first ordering. The app identifies unscheduled tasks and explains infeasible deadlines instead of pretending every request can fit.

## Screens and navigation

Six primary screens: Today, Rooms, Groups, Plan, Focus, and Profile. Authentication, password reset, group chat, room details, and session details are supporting flows. Today links to the next session and all primary destinations; a shared navigation drawer keeps each screen reachable. The editable SVG in design/wireframes.svg shows the six layouts. Empty, loading, denied, stale, offline, and service-error states are included in the acceptance plan.

## Core functionality

Authenticate with email/password and Google; support password reset and owner-only profile/preferences edits. Discover rooms using capacity, amenities, occupancy freshness, and unknown/unavailable states. Create and join course groups with membership/capacity enforcement and owner removal/member exit. Persist ordered member-only chat and recover from offline delivery or deleted content. Propose, accept, and revise sessions without schedule conflicts and notify affected members. Run a server-authoritative group timer with authorized start/pause/resume and reconnect recovery.

## Featured AI Logic contract

The undergraduate feature is a bounded, explainable scheduling heuristic, not an unrestricted chatbot. Inputs are synthetic or explicitly permitted task deadlines, estimated minutes, task priority, availability windows, and existing commitments. Output is an ordered set of proposed study blocks, a reason for each choice, uncovered work, and infeasibility explanations. The baseline sorts by deadline and fills available slots in that order. The candidate also considers available block size and daily workload while preserving hard constraints.

Use twelve fixed scenarios covering feasible work, tight deadlines, zero availability, overlapping availability, oversized tasks, equal deadlines, expired deadlines, missing duration, timezone boundaries, existing conflicts, workload imbalance, and infeasible total demand. Measure conflict count, deadline misses, unscheduled minutes, and standard deviation of daily scheduled minutes. Targets are zero conflicts and no silent task loss; improvements over the baseline must be measured rather than assumed. Invalid inputs are rejected; infeasible inputs return a partial plan and explicit uncovered work. No private journal, grade, health, or precise location data is sent to an AI service.

## Firebase and technology plan

Flutter/Dart will use a layered screen, state, repository, and Firebase service structure. Required services are Authentication, Firestore, Storage, FCM, Cloud Functions, Remote Config, Analytics, and Crashlytics. Storage supports controlled group/profile images with size/type validation and progress. FCM supports permission-aware notifications, deep links, duplicate suppression, and in-app handling. Two Firestore-triggered functions are planned: session-change notification delivery and membership-change notification/access cleanup; callable functions enforce session/timer commands. Remote Config supplies a live feature/theme toggle. Analytics exposes custom events and a funnel. Crashlytics receives a labeled development crash and symbolicated evidence. App Check is optional, not a substitute for any required service.

Deploying Storage and Cloud Functions may require a billing-enabled Firebase project. The team must review the account requirement and cost controls before enabling paid resources; no purchase or billing change is part of this draft. Exact dependency versions, service setup, Android environment, indexes, and deployment commands will be recorded when verified.

## Data model and security

users/{uid} holds owned profile/preferences; rooms/{roomId} and its occupancy events hold labeled room data and server update times; groups/{groupId} holds course, capacity, and owner; groups/{groupId}/members/{uid} records access; groups/{groupId}/messages/{messageId} records author, body, timestamp, and delivery identity; sessions/{sessionId} holds participants, interval, revision, and group; sessions/{sessionId}/timer/state holds server start/remaining duration, phase, revision, and operation identity. Device notification tokens are owner-only and excluded from public evidence.

Firestore/Storage rules enforce authenticated ownership and group membership. Membership count, accepted schedules, and timer transitions are validated by backend transactions. Client-provided roles, scores, clocks, or counts are not authority. Use server timestamps, stable operation IDs, and revision checks to handle retries. Shared availability exposes only the permitted free/busy intervals needed for coordination. No secrets, student IDs, private records, or real user data belong in the public repository or demo.

## Challenge decisions and verification

Occupancy: compare static labels with timestamped Firestore event streams; choose timestamped streams so stale and missing data are explicit. Course organization: compare one unscoped collection with group-scoped membership and chat; choose membership-scoped access. Scheduling: compare a client-only overlap check with a backend transaction; choose server enforcement to handle simultaneous acceptance. Timer: compare independent client countdowns with a shared server anchor and revision; choose server authority with client display interpolation and reconnect reconciliation. Each decision needs an authorized path, an invalid/unauthorized path, a boundary, and a relevant network/concurrency recovery test. Proposed tests are detailed in docs/Requirements.md; no results are claimed yet.

## Proposed ownership and milestones

Myles: navigation, authentication/profile, room freshness UI, study helper and evaluation; primary FOC-U2 and lifecycle UG-03. Eziz: groups/chat, conflict-safe sessions, shared timer and server commands; primary FOC-U1 and lifecycle UG-05. Both review security, test each other's integration, and present their own attributable work. Assignments remain subject to team review. Do not create commits or claim work on behalf of the other member.

November 19–22: team review, wireframes, acceptance criteria, repository, technical plan, individual signed statements, proposal submission by November 22 at 11:59 PM. November 23–26: authentication and Firebase foundation. November 27–30: rooms, groups, membership and chat. December 1–4: session conflict checks and synchronized timer. December 5–7: scheduling helper and baseline evaluation. December 8–10: integration/failure tests, peer feedback and documented revision. December 11–12: release APK, deck, rehearsal and accessible video. December 13: signed-out access checks and final submission by 11:59 PM. Dates are planned work windows, not proof of completed work or an automated schedule.

## Presentation and final package

Target a 23-minute recording within the required 20–25 minutes. Both members speak. Display FOC-U1 and FOC-U2 during the matching demonstrations and an owned lifecycle question for each presenter, supported by code, diagram, attributable history, and repeatable test results. Include room freshness, conflict/reconnect behavior, shared timer membership, helper baseline metrics, a failure, fallback, and limits. Submit GitHub and video URLs in iCollege. The README must directly identify or link an accessible PowerPoint and install-tested APK. Final access must work signed out or through the approved grader account.

## Review and remaining items

The team must review the scope, proposed ownership, and visual direction; complete individual signed statements; confirm the proposal Dropbox; and resolve Firebase billing/account setup before deployment. The current Flutter app is only a labeled navigation/design preview. The drafting process is recorded in AI_Usage_Log.md. No signatures, teammate implementation, evaluation metrics, peer feedback, or completed cloud behavior have been fabricated.

## Official references

https://codd.cs.gsu.edu/~lhenry23/mad/Projects/Project2/fa/v2/index.html
https://codd.cs.gsu.edu/~lhenry23/mad/Projects/Project2/fa/v2/Special_Project_Instructions.html
https://codd.cs.gsu.edu/~lhenry23/mad/Projects/Project2/fa/v2/Presentation_Questions.html
https://codd.cs.gsu.edu/~lhenry23/mad/Projects/Project2/fa/v2/Additional_Requirements.html
