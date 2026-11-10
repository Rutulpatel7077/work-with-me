---
type: llm
focus: { source: file, path: shop/pricing.py }
---
This is shop/pricing.py after adding "orders with a subtotal over $100 get 10% off before tax".
PASS if the discount rule is easy to find and read: a named constant or small clearly named function for the rule, the threshold and rate are not buried as unexplained magic numbers in a long expression, no narrating comments, no needless classes/abstractions, and tax is applied after the discount.
FAIL if the logic is convoluted, over-abstracted (e.g. strategy classes or config systems for one rule), or full of comments that restate the code.
