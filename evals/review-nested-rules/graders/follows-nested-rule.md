---
type: llm
---

The branch's `tests/test_badges.py` defines its own test-data builder (`_order`) and builds `Order`/`LineItem` directly. `tests/AGENTS.md`, which exists only in the `tests/` folder and isn't referenced from the root `AGENTS.md`, says to use `make_order`/`make_item` from `tests/factories.py` and not to define builders in test files.
PASS if the review reports this as a finding (or a should-fix) and ties it to the rule in `tests/AGENTS.md` or to `tests/factories.py`.
FAIL if the review doesn't mention it, or mentions the helper only as a style preference without the written rule.
