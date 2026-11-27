# Self-review: reviewing code this session wrote

Loaded by the review skill when this session wrote or edited the code under review. The author's memory of the change stands in for what is actually on the page, so the author misses the same things twice: once writing, once reviewing. This mode takes the author out of the loop.

## 1. Run the review in a fresh-context agent

Don't review inline. Spawn one agent (`wwm-verifier` if it fits, else a general agent) and give it only:

- the repo path and the scope (base ref and whether to include staged and uncommitted work);
- the path to the review skill's `SKILL.md`, with an instruction to follow steps 1, 3, and 4 and this file's authorship checks;
- the ticket key or link, and the user's original request quoted word for word.

Don't pass the plan, your summary of the change, the decisions made along the way, or what you suspect is wrong. Those anchor the reviewer to your reading. Relay its report unedited, then add your own response to each finding below it. If you can't spawn an agent, review inline but treat every file as unread: print each one before judging it.

## 2. Scope

No PR exists yet, so review committed and uncommitted work against the base: `git diff $(git merge-base <base> HEAD)` (working tree, not `..HEAD`), plus untracked files from `git ls-files --others --exclude-standard`. List untracked files that should be committed, or must not be (scratch scripts, `.env`, debug output).

## 3. Run the repo's checks locally

CI hasn't run yet, so run what it would: the format, lint, and typecheck check scripts (`fmt:check`, never a `--fix` or write mode) and the unit tests for the touched packages, through the repo's own scripts. Skip suites that need secrets, Docker, or cloud access, and name them as "not run". A failing typecheck or test is a **Must fix**.

## 4. Checks for agent-written code

Run these in addition to step 3 of the review, and report them under their own heading:

- **Written rules broken by copying a neighbor.** Agents match the nearest file. Check each changed file against the instruction-file rules from review step 1, not against its siblings.
- **Invented conventions.** A new helper, file layout, naming scheme, or test-data builder where the repo already has one.
- **Tests bent to pass.** Tests deleted, skipped, or focused (`.skip`, `.only`); assertions loosened or swapped for weaker ones; expected values changed to match new output without a reason; the unit under test mocked.
- **Errors silenced, not fixed.** New `as`, `!`, `any`, `@ts-ignore`, `eslint-disable`, `# type: ignore`, `# noqa`, empty `catch`, or `?.`/`??` added where the value was never null.
- **Behavior lost in a rewrite.** When the work was redone to match another file or a reviewer's request, compare the final diff with what the first version did: fallbacks, accessibility attributes, and assertions often disappear without anyone saying so.
- **Leftovers.** Debug logging, commented-out code, TODOs without an owner, hard-coded IDs or dates from a test run, scratch files.
- **Unverified API use.** A library option, config key, or upstream field that doesn't exist in the installed version or the upstream contract. Check the installed types or source.

## 5. Hand-back

Start with a verdict: **ready to push**, **push after fixing N items**, or **rework first**. Then the review report as usual. End with 3–8 bullets on what the change actually does, each with a file anchor, as a draft for the PR description, plus the **Assumptions** lines from "Considered and dismissed".

When the user asks you to fix the findings, follow the review skill's step 6: the fixes get their own review before anything is committed or pushed.
