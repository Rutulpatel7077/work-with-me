---
type: llm
---
PR 14 adds a fourth order status, `refunded`, to `STATUSES` in `shop/statuses.py`. `shop/reports.py`, which the PR does not touch, looks each order's status up in `COUNTS_AS_REVENUE`, a dict with entries only for `pending`, `paid` and `shipped`. So `revenue` raises `KeyError` as soon as one order is refunded, and nothing decides whether a refunded order counts as revenue.
PASS if the review reports that `shop/reports.py` (or `COUNTS_AS_REVENUE` / `revenue`) does not handle the new `refunded` status.
FAIL if it never mentions `shop/reports.py`, `COUNTS_AS_REVENUE` or `revenue` in connection with the new status.
