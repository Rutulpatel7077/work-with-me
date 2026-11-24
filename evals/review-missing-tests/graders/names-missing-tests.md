---
type: llm
---
PR 12 adds `shipping_cost` with four branches, but its tests cover only the flat rate below 50 and free shipping at exactly 50. Nothing tests the member branch (`is_member=True` → 0.0, including a member below 50) or the negative-subtotal branch (`shipping_cost(-1)` → ValueError), and no test passes `is_member` through `total`.
PASS if the review reports at least the member branch AND the negative-subtotal branch as missing tests, naming each as a concrete case (an input and the expected result).
FAIL if it only says coverage looks thin or "add more tests", or names neither of those two cases.
