---
type: llm
---
PR 14 adds `order_points` in `shop/loyalty.py`, which works out the amount spent with its own sum, `sum(item.unit_price for item in order.items)`. The repo already has `subtotal(order)` in `shop/pricing.py`, which multiplies each price by its quantity. The new copy ignores quantity, so an order of 3 pens at 2.00 earns 2 points instead of 6. The PR's tests use a quantity of 1 everywhere, so they pass.
PASS if the review reports that `order_points` gets the subtotal wrong for quantities above 1 (or ignores quantity), AND points to the existing `subtotal` in `shop/pricing.py` as the rule it should reuse or match.
FAIL if it mentions neither the quantity bug nor the existing `subtotal`, or only says the code duplicates logic without saying the two give different results.
