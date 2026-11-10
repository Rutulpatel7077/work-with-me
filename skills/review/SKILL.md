---
name: review
description: Human-style code review of a diff, branch, or GitHub PR. Use for "review this", "review my changes", "review PR 123", or before handing work back. Checks correctness, readability, and simplicity, and when a PR exists, reads existing reviewer and bot comments first so it doesn't repeat them.
---

# Code review

Review the way a careful senior teammate would: is it correct, can the next person read it, is it as simple as it could be? Report findings. Don't apply fixes unless asked.

## 1. Find the scope

- A PR number or URL → that PR.
- Otherwise the current branch against its base (`git merge-base HEAD origin/main`, or the default branch), plus uncommitted changes.
- A path or file the user names → that.

Read the PR description, linked issue, or commit messages to understand the intent. If you can't tell what the change is supposed to do, ask.

## 2. Read existing comments first (when there's a PR)

If `gh` is installed and authenticated and the scope is a PR, collect what others already said:

```bash
gh pr view <n> --json title,body,reviews,comments
gh api repos/{owner}/{repo}/pulls/<n>/comments --paginate   # inline review comments
```

Note each point raised, who raised it (person or bot, such as Copilot, CodeRabbit, Bugbot), and whether it was resolved or answered. If `gh` is missing or there's no PR, skip this step and say so in one line.

## 3. Review the change

Read the full diff, then the surrounding code for anything the diff touches. Check:

- **Correctness.** Logic errors, off-by-one, null and empty cases, error handling, races, wrong assumptions about a dependency's API (use the **research** skill when unsure).
- **Tests.** Does a test cover the new behavior? Would it fail if the change were reverted? Run the tests if you can.
- **Readability.** Could a teammate understand each function in one read? Clear names, no needless indirection, no dead code, no comments that restate the code.
- **Simplicity.** Is there a smaller change that does the same thing? Abstractions with one caller, unused options, duplicated logic that already exists in the codebase.
- **Consistency.** Matches the patterns and conventions already in the repo.
- **Security and data.** Input validation at boundaries, secrets in code, injection, destructive operations.

Verify a suspected bug before reporting it when you can: run a test, a script, or trace the exact path. Label anything unverified as a suspicion.

## 4. Report

Group findings by severity: **Must fix** (bugs, security, data loss), **Should fix** (readability, missing tests, simplicity), **Nit** (optional polish). Each finding gets the file and line, what's wrong, why it matters, and a suggested fix.

Then a separate section:

**Already raised.** Points from step 2 that match a real problem, one line each: "`file:line`, already raised by @reviewer (or bot name), still unaddressed. Agree." Don't re-explain them. If you disagree with an existing comment, say so in one line with the reason. Leave out existing comments that were resolved.

End with an overall verdict in one or two sentences: ready to merge, ready after the must-fixes, or needs rework.

Don't post anything to GitHub unless the user asks.
