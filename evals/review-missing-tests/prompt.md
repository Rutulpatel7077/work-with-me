---
description: "Review a PR with green CI whose new branching logic is only half tested: name the untested cases."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Review PR 12. Use ./bin/gh for GitHub (it's already authenticated); scripts that call `gh` need `./bin` first on PATH.
