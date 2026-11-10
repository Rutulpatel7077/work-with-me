---
description: "Review a PR whose CI is green on the head commit: cite CI, don't re-run the suite."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Review PR 7. Use ./bin/gh for GitHub (it's already authenticated).
