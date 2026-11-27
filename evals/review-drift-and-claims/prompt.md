---
description: "Review a PR with green CI that re-implements an existing rule slightly wrong and states a guarantee in a docstring the code doesn't keep."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Review PR 14. Use ./bin/gh for GitHub (it's already authenticated); scripts that call `gh` need `./bin` first on PATH.
