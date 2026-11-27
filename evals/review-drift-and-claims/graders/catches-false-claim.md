---
type: llm
---
In PR 14, the docstring of `PointsLedger.award` and the PR description both say awarding is idempotent: the same order awarded twice never double-counts. The code adds the order's points to the balance on every call and keeps no record of which orders it has seen, so a checkout retry awards the points twice.
PASS if the review reports that `award` is not idempotent (awarding the same order twice double-counts) and ties that to the claim in the docstring or the PR description.
FAIL if it accepts the idempotency claim, or doesn't mention it.
