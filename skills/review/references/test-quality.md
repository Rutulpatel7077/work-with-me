# Test quality: check each assertion

Loaded by the review skill's **Tests** check, and by step 6 when fixes add tests.

"Would the test fail if the change were reverted?" is too weak. Any test that renders a newly added component fails on revert, however loose its assertions are. Judge each assertion against a targeted break of the behavior it names: if you broke exactly that behavior, would this line fail?

## Assertions that pass on broken code

Flag each one and name the stronger form:

- **Negated-only checks.** `not.toHaveClass('negative')`, `not.toBeInTheDocument()`, `assertNotIn`, `not.toContain`. They pass when the thing is absent for any reason, including the feature silently not rendering. Pair each with a positive twin: `toHaveClass('positive')`, the exact element that should be there instead.
- **Counts.** `getAllBy…().toHaveLength(2)`, `assert len(rows) == 2`. A count pins whatever happens to render, including a known duplicate, and fails the day someone fixes it. Find the specific element and assert its exact content.
- **Presence instead of value.** `toBeInTheDocument()`, `is not None`, `toBeTruthy()` where the requirement names a value. Assert the value.
- **Config with no value assertion.** Column definitions, field-to-formatter maps, route tables, and permission maps are logic even though they have no branches. A test that checks only the headers or keys lets a value land in the wrong column. Assert at least one full row or entry, value by value, and the empty or missing case (gap marker, fallback text).
- **Expected values derived from the code under test**, or from data the test built itself. Derive them from the requirement.
- **State found through styling.** Selecting by `data-state`, a class name, or a test id when the behavior is visible by role and name. It hides accessibility gaps; see the review's Accessibility check.
- **Weakened during a refactor.** An existing assertion loosened, swapped for a styling check, or deleted to make a refactor pass. Diff the test files against the base for this.

## Prove it bites

When you can't tell by reading whether an assertion would catch a break, mutate the code once, run only that test, then restore:

```bash
cp <file> <scratch>/orig            # keep a copy
# make one targeted break: point a column at the wrong field, drop a fallback, flip a class
<repo's single-test command> <test file>   # must FAIL
cp <scratch>/orig <file>            # restore, then confirm: git diff --quiet -- <file>
```

To check that a whole test file guards the change, run it against the base version of the source: `git show <base>:<file> > <file>`, run the test, then restore with `git checkout -- <file>`. That restores the index copy, so only do it when the change is committed or staged.

Report each weak assertion as a **Should fix** with the stronger assertion written out, and say whether you proved it with a mutation.
