---
description: "A new feature goes in its own module, test-first, without spreading changes across unrelated files."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Go ahead and build this, no need to check with me first: export orders to CSV, one row per order with order id, customer, item count, subtotal, tax and total. Put it in shop/export.py.
