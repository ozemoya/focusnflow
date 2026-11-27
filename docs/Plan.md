# Incremental development plan

Board columns: Backlog -> Ready -> In progress -> Review -> Verified -> Done. A feature moves to Done only after its owner links implementation, review and reproducible evidence. Proposed responsibility is not a contribution claim. Each member commits only their own work; no rewritten or invented history.

| Dates in 2026 | Increment | Planned result |
| --- | --- | --- |
| Nov 19–22 | Proposal and setup | Six layouts, scope, acceptance matrix, repository, team review, individual statements and proposal by 11:59 PM Nov 22. |
| Nov 23–26 | Cloud foundation | Auth including social/reset; schema, rules and initial service plumbing, each separately verified. |
| Nov 27–30 | Rooms and groups | Fresh/stale/unknown occupancy, membership capacity, private ordered chat and image handling. |
| Dec 1–4 | Sessions and timer | Conflict-safe acceptance; two-device timer start/pause/resume and reconnect. |
| Dec 5–7 | Helper evaluation | Fixed scenarios, deadline-first baseline, measured metrics and fallback. |
| Dec 8–10 | Reliability and revision | Required Firebase console evidence, failure tests, genuine peer feedback and tested revision. |
| Dec 11–12 | Packaging and rehearsal | Install-tested release, deck, both presenters, 23-minute target recording and accessible hosting. |
| Dec 13 | Submission | Verify all four artifact links; submit GitHub and video URLs before 11:59 PM. |

These are work windows, not a scheduled automation or completed milestones. Keep increments small enough to review and demonstrate. Record actual progress, failures and scope changes when they happen.

November 26 checkpoint: cloud foundation is partial. Project/Android registration, local rules, SDK adapter and startup/session UI are implemented; real provider activation, registration/social flow, installed-device persistence and Firestore integration remain open. Finish account verification before authenticated rooms/groups. Carry this work into the next increment rather than claiming the Nov 23–26 phase complete.

November 27 checkpoint: email/password is now enabled and a disposable live REST lifecycle check passed with cleanup. Native account registration/login/persistence, Google flow and Firestore integration remain open; REST evidence does not complete the device/account phase.
