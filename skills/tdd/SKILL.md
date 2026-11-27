---
name: tdd
description: Runs a test-first workflow for bug fixes, behavior changes, and any test you write. Use whenever writing or editing a test file (`*.test.*`, `*_test.*`, `test_*.py`), adding a test a review or PR comment asked for, changing an existing assertion during a refactor, fixing a bug, or adding or changing behavior, or when the user mentions tests, TDD, a regression, or "make sure it works". Write a failing test, confirm it fails for the right reason, then change the code until it passes.
argument-hint: [bug or behavior]
---

# Test-driven changes

The default for any change to behavior: prove the problem with a test before you change the code. A test you never saw fail proves nothing.

## Steps

1. **Learn the project's testing setup.** First read the testing rules in every `AGENTS.md` or `CLAUDE.md` between the test's folder and the repo root (only the root one is loaded for you). Then find the test runner, where tests live, and how existing tests are written (read two or three nearby ones). Find the command that runs a single test. Match their style, helpers, and fixtures, except where a written rule says otherwise: the rule wins over a neighbor that breaks it, so use the required helpers, factories, and interaction APIs even if the next file doesn't.
2. **Pin the behavior.** Write down the expected behavior and the current behavior in one sentence each. For a bug, reproduce it first, locally or against test data. Never against production or shared cloud resources.
3. **Write the failing test.** The smallest test that would have caught the bug, or that describes the new behavior. Assert what a caller can observe (return values, output, state, rendered UI), not internal calls.
4. **Run it and watch it fail.** Confirm it fails *for the reason you expect*. If it passes, or fails for an unrelated reason (import error, typo, missing fixture), fix the test before you touch the code.
5. **Change the code.** The smallest change that makes the test pass.
6. **Run it and watch it pass.** Then run the surrounding test file or suite to catch regressions. Run the type checker and linter if the project has them.
7. **Clean up.** Refactor only with the tests green. Re-run after.

## When there is no test setup

Look again first: `package.json` scripts, `pyproject.toml`, `Makefile`, `Cargo.toml`, CI config. If the project truly has no tests, ask the user whether to add a test framework. Recommend the standard one for the stack. Meanwhile, verify with an executable check: a script, a curl command, a CLI run, or a browser check.

## When a failing test is impractical

Some changes can't get a cheap, honest test: production-only state, heavy infrastructure, pure UI polish, timing behavior. Do not write a bad test to satisfy the process. A bad test mostly tests mocks, encodes implementation details, or is flaky. Instead:

- Use the closest executable check (repro script, CLI command, browser automation, log assertion).
- **Say so in your report.** Name what you used instead and why a test wasn't practical.

## Is it a good test?

A test should check what the code's users can see: return values, errors, saved state, requests sent, output shown. Not private helpers or internal call order. Check every test you write against two imagined edits:

- **Break the behavior** (wrong value, skipped effect, effect done twice). The test must fail. If it still passes, it proves nothing. Usual causes: a loose assertion, an expected value computed by the code under test, or asserting on data the test built itself. Loose assertions to watch for: a negated-only check (`not.toHaveClass(...)`, `assertNotIn`) that also passes when nothing renders, a count of matching nodes, presence where the requirement names a value, and config (columns, maps) tested by its keys but not its values. When unsure, make the break for real, run the test, and restore.
- **Change the internals, same observable results.** The test must still pass. If it fails, it's pinned to the implementation and will break on every refactor.

Derive expected values from the requirement, not from running the code.

## Guardrails

- Never change a test just to make wrong code pass.
- Never weaken or delete an existing assertion unless the intended behavior genuinely changed, and say so.
- Keep the new test focused. No unrelated fixture churn.
- Make flaky behavior deterministic (inject the clock, seed the random source) instead of retrying.

## Report

- The test that failed before, with the failure message.
- The same test passing after, plus the wider suite result.
- Or, if you skipped the test, what you ran instead and why.
