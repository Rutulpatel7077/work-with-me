# Plan template

Use this whenever you hand implementation work to another agent: a delegated change, the winning plan from an arena, or a plan the user wants to run later. Adapted from shadcn's `improve` skill (MIT).

Write for the weakest plausible executor: a cheaper model that has never seen this conversation. It follows explicit instructions well and fills gaps badly. Three things make a plan safe to hand over:

1. **Self-contained.** Everything it needs is in the plan: files, code excerpts, conventions, commands. Never "as discussed above".
2. **Verification gates.** Every step ends with a command and the result to expect, so the executor never has to judge whether it worked.
3. **Hard boundaries.** Files in scope and out of scope, and STOP conditions for when reality doesn't match the plan.

Write excerpts from your own reads of the code, not from another agent's summary. Line numbers in a summary are leads, not facts.

## Template

```markdown
# <What will be true when this is done>

> **Executor:** Follow the steps in order. Run each verification and confirm the
> expected result before moving on. Touch only files in scope. If a STOP
> condition happens, stop and report. Don't improvise. Never commit, push, or
> open a PR unless told to.
>
> **Drift check (first):** `git diff --stat <planned-at commit>..HEAD -- <in-scope paths>`
> If an in-scope file changed, compare it with "Current state" below. A mismatch is a STOP condition.

## Status
- **Planned at:** commit `<short sha>`, <date>
- **Effort:** S | M | L
- **Risk:** LOW | MED | HIGH, with one line on why
- **Depends on:** <other plans, or none>

## Why
2 to 5 sentences: the problem, what it costs today, what improves. The intent is what lets the executor make a correct call when a detail is off.

## Current state
- Each relevant file with one line on its role.
- Short excerpts of the code as it is now, with `file:line`, so the executor can confirm it's looking at the right thing.
- The conventions to match, pointing at one example file: "Errors use the Result type, see `src/lib/result.ts` and its use in `src/users/api.ts:40-60`."
- Any vocabulary or decisions from the project's docs (ADRs, CONTEXT.md, DESIGN.md) the work must honor, quoted.

## Commands
| Purpose | Command | Expected |
| --- | --- | --- |
| Install | `<exact command>` | exit 0 |
| Tests | `<exact command, with a filter if useful>` | all pass |
| Typecheck / lint | `<exact command>` | exit 0 |

Commands come from the repo and were run once while planning, not guessed.

## Scope
**In scope** (the only files to change): ...
**Out of scope** (don't touch, even if they look related, and why): ...

## Steps
### 1. <imperative title>
Exactly what to do, naming files and symbols. Show the target shape when it matters.
**Verify:** `<command>` → <expected result>

(Keep each step small enough to verify on its own. Order them so the code isn't broken between steps: add the new path, switch callers, then remove the old path.)

## Tests
Which tests to write first (per the tdd skill), in which file, covering which cases, modeled on which existing test. The failing-first run is a step with its own verification.

## Done when
Machine-checkable, all must hold:
- [ ] `<test command>` passes, including the new tests
- [ ] `<typecheck / lint>` exits 0
- [ ] `git status` shows only in-scope files changed

## STOP conditions
Stop and report instead of improvising if:
- The code doesn't match "Current state".
- A step's verification fails twice after a reasonable fix.
- The change seems to need an out-of-scope file.
- <the key assumption this plan rests on> turns out to be false.

## Notes for the next owner
What future changes will interact with this, and what a reviewer should look at closely.
```

## Before handing it over

- Could an agent that has never seen this repo or conversation follow it with only this file and the repo?
- Is every verification a command with an expected result, never "make sure it works"?
- Does every step name exact files and symbols?
- Are the STOP conditions about this plan's real risks, not boilerplate?
- No secret values anywhere. Name the location and type only.
