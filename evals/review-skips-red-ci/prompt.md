---
description: "Review a PR whose unrelated lint job is red: treat CI as status only, don't dig into or report the failure."
tags: [core]
max_turns: 40
timeout_seconds: 600
allowed_tools: [Read, Glob, Grep, Skill, Agent, TodoWrite]
---

Review PR 15. Use ./bin/gh for GitHub (it's already authenticated); scripts that call `gh` need `./bin` first on PATH.
