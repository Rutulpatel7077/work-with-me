# work-with-me

My way of working with AI coding agents, packaged as a Claude Code plugin. The agent works like a trusted senior engineer on the team: it thinks before acting, asks when something is unclear, looks things up instead of guessing, fixes bugs test-first, and hands work back for review instead of committing.

## What's inside

| Piece | What it does |
| --- | --- |
| `skills/work-with-me` | The core working style: understand, clarify, research, plan, test-first, verify, hand back. Routes to the skills below. |
| `skills/tdd` | Failing test first, watch it fail for the right reason, then fix. Says so when a test isn't practical. |
| `skills/research` | Checks the installed version and current docs before answering about libraries, APIs, or anything recent. |
| `skills/arena` | Design bakeoff: several models plan independently, a judge on a different model compares them, the best plan absorbs the others' best ideas. |
| `skills/review` | Human-style review for correctness, readability, and simplicity. On a GitHub PR it reads existing human and bot comments first and lists them as "already raised". |
| `agents/wwm-worker` | Delegate that implements changes test-first. |
| `agents/wwm-researcher` | Delegate that researches and returns a sourced answer. |
| `hooks/session-start.sh` | Loads a short summary of the working style into every session. |
| `hooks/git-guard.sh` | Makes Claude Code ask before `git commit`, `git push`, `gh pr create/merge`, and `gh repo create`. |
| `skills/work-with-me/references/models.md` | Which model each role uses. Edit it to change models. |

## Install

On any machine with Claude Code, in a session:

```
/plugin marketplace add Rutulpatel7077/work-with-me
/plugin install work-with-me@work-with-me
```

Or from a shell:

```bash
claude plugin marketplace add Rutulpatel7077/work-with-me
claude plugin install work-with-me@work-with-me
```

If the repo is private, the machine needs git access to it (run `gh auth login` first).

**Updates.** After pushing changes, bump `version` in `.claude-plugin/plugin.json`, then on each machine run `claude plugin marketplace update work-with-me` and start a new session. To update automatically, open `/plugin`, go to Marketplaces, select `work-with-me`, and turn on auto-update.

## Use

It's on by default once installed. The session-start hook tells the agent to follow the working style, and the skills load when a task matches. You can also call them directly:

- `/work-with-me:arena` to run a design bakeoff
- `/work-with-me:review 123` to review PR 123
- `/work-with-me:tdd` or `/work-with-me:research` to force either step

## Extend it

- **New capability.** Add `skills/<name>/SKILL.md` with a `description` that says when to use it. Mention it in the core skill's loop if it should run by default.
- **New agent.** Add `agents/<name>.md`.
- **Change behavior.** Edit `skills/work-with-me/SKILL.md`. Keep it short. Each rule should change what the agent does.
- **Enforce a rule.** If you keep repeating an instruction, turn it into a hook or a script instead of more text.

While editing, test locally without installing:

```bash
claude --plugin-dir .      # then /reload-plugins after each edit
bash tests/run.sh           # hook tests, JSON checks, claude plugin validate
```

## Credits

Inspired by [pstack](https://github.com/cursor/plugins/tree/main/pstack) by Lauren Tan (MIT), especially its arena, TDD, and principle-driven approach. The text here is written from scratch.
