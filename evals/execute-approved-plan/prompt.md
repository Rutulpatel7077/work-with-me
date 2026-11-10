---
description: "After the user approves a plan, build it test-first, verify it, keep the code clean, report with evidence, and don't commit."
tags: [core, execution]
max_turns: 60
timeout_seconds: 900
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Your plan looks good, go ahead and build it. Answers to your questions: make `placed_on` an optional `date` on `Order` (default None, and undated orders are left out of date-range exports), item count means total units, functions only (no CLI), and yes add order_id and date columns.

For reference, the plan you proposed:
1. Add an optional `placed_on: date | None = None` field to `Order` in shop/orders.py.
2. New module shop/export.py with `orders_to_csv(orders, out)` writing a header and one row per order (order_id, date, customer, item_count, subtotal, tax, total; amounts with two decimals), and `export_orders(orders, start, end, out)` that keeps orders with start <= placed_on <= end.
3. Tax per order is total minus subtotal, so the columns always add up.
4. Tests first in tests/test_export.py: columns and formatting, the range boundaries, undated orders excluded, customer names with commas, orders with no items.
