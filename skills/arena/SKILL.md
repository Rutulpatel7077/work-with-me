---
name: arena
description: Design bakeoff for non-trivial plans. Several agents on different models each propose a plan independently, a judge from a different model compares them against a rubric, and the best plan is merged with the strongest ideas from the others. Use for /arena, "arena this", architecture decisions, new features with real design alternatives, or when one attempt would lock in the wrong shape.
---

# Arena

One agent's first plan anchors everything after it. Arena gets several independent plans, compares them honestly, and combines the best of them before any code is written.

Use it when the shape of the solution is genuinely open: a new feature touching several modules, a data model, an API design, a migration strategy. Skip it for clear bug fixes and small changes. If you're unsure whether the task deserves it, ask the user in one line.

Track the phases in a todo list: Frame, Fan out, Judge, Pick, Merge, Confirm.

## 1. Frame

1. **Ground yourself first.** Read the code the change touches. Run the **research** skill for any third-party piece. Write a short grounding note (relevant files, constraints, current behavior) to a shared path such as `.arena/<slug>/grounding.md` inside the project, or the session scratchpad.
2. **Write the task.** One prompt every runner gets verbatim: the user's goal, the grounding note path, constraints, and what to produce (a plan with data shapes, interfaces, files to change, test strategy, and risks, plus the alternatives it considered and rejected).
3. **Write the rubric.** 3 to 6 criteria specific to this task, for example "fits the existing module boundaries", "smallest public API", "testable without mocks", "handles X edge case". Runners don't see it. The judge and you use it.
4. **Pick runners** from the `arena runners` line in [../work-with-me/references/models.md](../work-with-me/references/models.md). At least two, on different models. Add a runner per extra design direction when the space is wide.

## 2. Fan out

Spawn all runners in one message, in the background, using the `work-with-me:wwm-worker` agent with plan-only instructions (no code edits). Each writes its plan to its own file (`.arena/<slug>/plan-<n>.md`). If a runner fails, continue with the rest and note it.

## 3. Judge

After every runner finishes, spawn one judge from the `arena judge` pool on a model **different from yours** (the main chat's model). The judge reads the rubric and every plan, scores each criterion per plan, and recommends a base plan with reasons. Meanwhile, read every plan yourself.

## 4. Pick

Score each plan against the rubric yourself, criterion by criterion. Compare with the judge. Agreement confirms the pick. If you disagree, read both rationales and decide. When two plans tie, prefer the simpler one with the smaller surface that a future maintainer can extend safely.

If the plans converge on the same shape, that's strong agreement. Take it. If they diverge wildly, the framing was too loose. Tighten the task and rerun.

## 5. Merge

Go through each losing plan for the one or two ideas worth adopting: an edge case, a better test strategy, a cleaner interface. Fold them in by hand so the final plan reads as one coherent design.

## 6. Confirm

Present the final plan to the user:

- The plan itself (data shapes, interfaces, files, tests, risks).
- Which plan was the base and why, and what the judge said.
- What was merged in from the others and what was rejected.

Wait for the user's go-ahead before implementing, unless they already said to proceed. Then implement with the **tdd** skill. Delete `.arena/` when done, or add it to `.gitignore`.
