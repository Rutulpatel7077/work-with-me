---
type: llm
---
PR 7's CI (unit-tests and lint) is green on the PR's head commit.
PASS if the review says the tests passed in CI (naming the CI jobs or the commit) and relies on that instead of claiming to have re-run the whole test suite locally. Running one targeted test or script to check a specific behavior is fine.
FAIL if the review says it re-ran the full test suite locally, or never mentions the CI result.
