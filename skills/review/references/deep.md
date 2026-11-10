# Deep review

Several agents on different models each try to break the change. A finding survives only if a run proves it. Different models catch different real bugs, and requiring proof filters out the confident-sounding noise.

## 1. Frame

- **Scope and intent.** From review steps 1 and 2: what the change is, what it's supposed to do, and the comments already raised. Restate the intent in two or three sentences (the **in-your-own-words** skill). If the intent is unclear, ask before spending agents.
- **Adversaries.** Take the models from the `deep review adversaries` line in [../../work-with-me/references/models.md](../../work-with-me/references/models.md). At least two, on different models.

## 2. Fan out

Tell the user in one line how many adversaries and which models you're starting before spawning.

Spawn every adversary in one message, in the background, with the `general-purpose` agent and `isolation: "worktree"` so each has its own copy of the repo and repro files can't collide. If the change is uncommitted, tell each adversary to apply it first with the patch you saved (`git diff > <scratchpad>/change.patch`, then `git apply` in its worktree).

Give each the scope, the intent, the already-raised comments, and this brief:

> Break this change. Prove each finding with a run against the real code: a failing test, a repro script, or command output that shows the wrong behavior. For a design, probe the current code or build a small prototype. Work only locally in your worktree. Never touch live systems, shared databases, or cloud resources. Report each finding with a title, the exact command, the output it printed, the output the intent requires, and two to four plain-language steps to reproduce it. Leave out anything you didn't run, including style, naming, and hypothetical future risks. No findings is a valid result.

## 3. Verify

Rerun each finding's command yourself. Keep it only when the output shows the failure and the failure breaks the intent. Merge findings with the same root cause, noting which adversaries found each. Drop the rest.

## 4. Report

Use the normal review report format (severity, file and line, how to reproduce, **Reproduced**, suggested fix, Already raised, verdict), plus:

- **Found by.** Which adversaries found each finding. Agreement across models is a strong signal.
- **Dropped.** Per adversary, how many findings were dropped and why (didn't reproduce, didn't break the intent, unverified).

Every kept finding is reproduced by definition. Say "no verified findings" if none survive.
