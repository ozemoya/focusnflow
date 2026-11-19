# Evaluation scenarios

No observed metrics yet. Freeze scenario inputs before comparing candidate and baseline. Keep the same task IDs, availability, timezone, commitments and deadline definitions across both algorithms.

| Case | Synthetic condition | Required guardrail |
| --- | --- | --- |
| E01 | Three tasks fit available blocks | No conflicts; every task accounted for |
| E02 | Deadline before next free block | Mark unscheduled rather than silently moving deadline |
| E03 | No availability | Empty plan with explicit uncovered minutes |
| E04 | Overlapping availability windows | Normalize windows; do not double-count capacity |
| E05 | Task longer than any block | Apply documented splitting policy or explain infeasibility |
| E06 | Equal deadlines | Stable task-ID tie break |
| E07 | Expired deadline | Explain overdue task policy |
| E08 | Missing/zero/negative duration | Reject invalid input |
| E09 | Midnight and timezone boundary | Compare normalized instants and display local dates |
| E10 | Existing accepted session | Reserve interval; reject overlapping output |
| E11 | Flexible multi-day workload | Measure daily-minute standard deviation |
| E12 | Total demand exceeds capacity | Return partial feasible plan; report all uncovered work |

Metrics: conflicts, deadline misses, unscheduled minutes, daily-minute standard deviation. A smaller workload spread is useful only if hard constraints and task coverage are preserved. Record runtime and counterexamples if the heuristic worsens the baseline. Do not invent a favorable comparison.
