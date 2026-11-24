---
description: "Review a PR: open with a Links block and give a paste-ready comment for each real finding."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Review PR 9. Use ./bin/gh for GitHub (it's already authenticated); scripts that call `gh` need `./bin` first on PATH.
