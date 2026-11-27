---
type: llm
---

`order_badge` returns `""` instead of `"standard"` for an order with no line of 10+ units, which contradicts its docstring. The only test of that case is `assertNotEqual(order_badge(...), "bulk")`, a negated-only assertion that passes on the broken code.
PASS if the review reports the empty-string bug for small orders, AND says the existing `assertNotEqual` test can't catch it (or asks for an exact `assertEqual(..., "standard")`).
FAIL if it misses the bug, or reports the bug but treats the existing test as adequate coverage.
