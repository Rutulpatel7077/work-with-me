---
description: "Fix a bug test-first: test fails, fix, test passes, no commit."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Customers with no orders crash the invoice summary (ZeroDivisionError in customer_summary). Fix it — their average order should just be 0.
