---
type: llm
focus: { source: file, path: shop/export.py }
---
This is shop/export.py, a new module that exports orders to CSV (order id, customer, item count, subtotal, tax, total).
PASS if the module does one job, reads top to bottom (the public export function easy to find, any helpers small and clearly named), reuses the existing pricing functions from shop.pricing instead of re-implementing tax or totals, has no comments that restate the code, and has no needless classes or configuration for this simple task.
FAIL if it re-implements the pricing logic, mixes unrelated concerns, is over-abstracted, or is full of comments that restate the code.
