# work-with-me

My way of working with AI coding agents, packaged as a Claude Code plugin. The agent works like a trusted senior engineer on the team: it thinks before acting, asks when something is unclear, looks things up instead of guessing, fixes bugs test-first, and hands work back for review instead of committing.

## What's inside

| Piece | What it does |
| --- | --- |
| `skills/work-with-me` | The core working style: understand, clarify, research, plan, test-first, verify, hand back. Routes to the skills below. |
| `skills/tdd` | Failing test first, watch it fail for the right reason, then fix. Says so when a test isn't practical. |
| `skills/research` | Checks the installed version and current docs before answering about libraries, APIs, or anything recent. |
| `skills/arena` | Design bakeoff: several models plan independently, a judge on a different model compares them, the best plan absorbs the others' best ideas. |
| `skills/review` | Human-style review for correctness, readability, and simplicity. `review deep` runs several models that each try to break the change, keeping only findings a run proves. Reproduces findings locally where it safely can and gives plain-language repro steps. On a GitHub PR it reads existing human and bot comments first and lists them as "already raised". |
| `skills/explain` | Explains a feature start to finish like one developer briefing another. Read-only agents investigate each part, every `file:line` citation is checked, and the result is a short HTML report. |
| `skills/unslop` | Strips AI slop from code, comments, and reports: narrating comments, commented-out code, defensive clutter, leftovers, hype words. Comments stay only for a non-obvious why, in plain language. Runs on your own diff before hand-back. |
| `skills/blast-radius` | Finds what a change could break outside the diff, and proves the key safety fact by running code. Review runs it for non-trivial changes. |
| `skills/catch-up` | Plain-language catch-up after time away, with every decision waiting on you and a recommendation for each. |
| `skills/reflect` | Mines the session for mistakes and corrections, and proposes edits to these skills, the project's CLAUDE.md, or a hook. Applies only what you approve. |
| `skills/in-your-own-words` | Restates your goal and the problem behind it, with assumptions marked, so misunderstandings surface early. |
| `agents/wwm-worker` | Delegate that carries out a written plan step by step, test-first, stops instead of improvising, and reports with evidence. |
| `agents/wwm-researcher` | Delegate that researches and returns a sourced answer. Read and web tools only, 30 turns max. |
| `agents/wwm-explorer` | Read-only investigator used by explain and reflect. Can read and search, nothing else. |
| `agents/wwm-verifier` | Fresh-eyes check of finished work: runs build, tests, lint, and the real app locally, then reports pass or fail with evidence. Doesn't edit. |
| `hooks/verify-stop.sh` | Opt-in per repo. If `.claude/work-with-me.json` has a `verify` command and files changed, it runs before Claude finishes. A failure goes back to Claude to fix. |
| `hooks/session-start.sh` | Loads a short summary of the working style into every session. |
| `hooks/git-guard.sh` | Makes Claude Code ask before `git commit`, `git push`, `gh pr create/merge`, and `gh repo create`. |
| `hooks/cloud-guard.sh` | Makes Claude Code ask before commands that change cloud resources, clusters, or published packages (terraform, kubectl, helm, aws, gcloud, az, docker push, publish, deploy CLIs). Read-only commands pass. |
| `skills/work-with-me/references/code-style.md` | How code should read: top to bottom like a story, one concern per module, simple, easy to change. Used when writing and reviewing. |
| `skills/work-with-me/references/rich-reports.md` | When and how to hand off long reviews and decisions as an HTML page instead of a wall of Markdown. |
| `skills/work-with-me/assets/report-template.html` | The shared HTML report template: themes, TL;DR box, steps, badges, optional diagrams. |
| `skills/work-with-me/references/planning.md` | Plan before code: the strong main agent plans (approach, research, test plan, steps, readiness check, open decisions), you review it, then cheaper agents carry out the pieces. |
| `skills/work-with-me/references/plan-template.md` | How to write a plan a cheaper agent can carry out safely: everything inlined, a verification command per step, scope limits, and STOP conditions. Used for arena results and any delegated change. |
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

**Updates.** The plugin has no `version` field, so every pushed commit counts as a new version. On each machine, run `claude plugin marketplace update work-with-me` and start a new session. To update automatically, open `/plugin`, go to Marketplaces, select `work-with-me`, and turn on auto-update.

## Use

It's on by default once installed. The session-start hook tells the agent to follow the working style, and the skills load when a task matches. You can also call them directly:

- `/work-with-me:arena` to run a design bakeoff
- `/work-with-me:review 123` to review PR 123
- `/work-with-me:explain <feature>` for a start-to-finish HTML walkthrough of a feature
- `/work-with-me:review deep` for a multi-model adversarial review
- `/work-with-me:catch-up` when you're back
- `/work-with-me:reflect` to turn this session's lessons into skill edits
- `/work-with-me:in-your-own-words` to check the agent understood you
- `/work-with-me:tdd` or `/work-with-me:research` to force either step

## Turn on the verify check in a repo

Add `.claude/work-with-me.json` to the project:

```json
{ "verify": "npm test" }
```

Use whatever command proves the project works (`pytest -q`, `make check`, `cargo test`). It runs only when the working tree has changes, at most once per stop, with a 10-minute limit.

## Cost and limits

- Each agent has a turn cap (`maxTurns`) in its file under `agents/`. The fan-out limit and models per role are in `skills/work-with-me/references/models.md`.
- `arena` and `reflect` start only when you type them, because they spend several agents. Other fan-outs say how many agents they're starting first.
- For headless runs, `claude -p --max-budget-usd 5 ...` is the only hard spending cap, and it counts subagents.
- `/usage` shows session cost. `/tasks` lists running agents, and `x` stops one.

## Fewer permission prompts

The guards only ask on commands that change things outside your machine, so they should be rare. To cut other prompts, run `/fewer-permission-prompts` to allow common read-only commands, or turn on Claude Code's sandbox.

## Test the whole setup (evals)

`tests/run.sh` checks the hooks and scripts. `evals/` checks behavior: does Claude, with this plugin loaded, actually work the way the skills say? Each case is a realistic request run against a small practice repo (`evals/_fixtures/shop`), with pass/fail checks on what Claude did. `claude plugin eval` also runs every case without the plugin, so you can see what the plugin changes.

| Case | Checks that Claude… |
| --- | --- |
| `clarify-vague-request` | asks about a vague request in one message, with a recommended answer for each question, before coding |
| `plan-before-feature` | plans a non-trivial feature, including a test plan, and flags the hidden ambiguity before coding |
| `research-not-memory` | looks up a version-specific library answer and cites sources instead of answering from memory |
| `tdd-bugfix` | reproduces a bug with a failing test before fixing it, and doesn't commit |
| `readable-feature` | adds a small feature test-first, as simple readable code |
| `unslop-comments` | removes narrating comments and commented-out code but keeps the real *why* comment |
| `review-finds-bug` | finds the planted off-by-one on a branch, reproduces it, and gives repro steps |
| `long-review-report` | delivers a long review as an HTML report with a short chat summary |
| `cloud-read-only` | diagnoses a crashing prod pod with read-only commands and hands the fix to you |
| `no-commit-typo` | fixes a typo without committing or pushing |

Run it (each run is real model usage; a full pass with the baseline costs a few dollars):

```bash
claude plugin eval . --scaffold --trust-plugin --runs 1 -j 6 \
  --allow-tools Write Edit Bash WebSearch WebFetch \
  --no-publish --max-cost-usd 20 --json evals/results/latest.json
python3 evals/summarize.py evals/results/latest.json            # scores and failed checks
python3 evals/summarize.py evals/results/latest.json --replies  # plus Claude's final replies
```

Use `--runs 3` before trusting a change, since one run of an agent is noisy. When Claude gets something wrong in real use, add a case for it: copy a case folder, change `prompt.md`, the setup script, and the graders. `/work-with-me:reflect` proposes cases too.

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

Inspired by [pstack](https://github.com/cursor/plugins/tree/main/pstack).
