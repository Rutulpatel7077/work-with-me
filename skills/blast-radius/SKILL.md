---
name: blast-radius
description: Finds what a change could break outside the diff, and proves the key safety fact by running real code instead of arguing it. Use for "what could this break", "blast radius", "is this safe to merge", reviewing a small diff you don't trust yet, or as part of the review skill for non-trivial changes.
argument-hint: [PR number | branch | file]
---

# Blast radius

Listing callers isn't the job, grep does that in a second. The job is finding the breakage grep won't show, and proving the change is safe instead of just sounding sure.

## How sure are you

A convincing write-up reads the same whether it's true or not. For each fact the change's safety depends on, get as far down this ladder as is cheap, and say where you stopped:

1. **You said so.** Worth nothing on its own.
2. **You pointed at the line.** A real `file:line`, or the dependency's own source.
3. **You traced it.** You walked the failure path step by step and showed it can't be reached.
4. **You ran it.** A script or test that calls the real code and fails loudly if you're wrong.
5. **You reproduced it in the running app**, locally.

Step 4 is usually one small script that imports the same library version the app uses and calls the exact function you're worried about.

## Steps

1. **Read the change.** The diff, every symbol it adds, changes, or removes, and what now behaves differently, including what the diff doesn't spell out.
2. **Find the one fact it's safe because of.** Most risky-looking changes are safe because of a single fact, such as "this only runs after the cache is already empty". If that fact holds, most risks clear at once. Spend your time here, not on a long list of maybes.
3. **Look where grep stops.**
   - Data that crosses a boundary: API responses, database columns, file and wire formats, other services or languages reading the same data.
   - Config and feature flags, environment differences.
   - Timing: async ordering, teardown, retries, concurrency.
   - The dependency's actual source at the installed version (use the **research** skill).
   - Code two or three hops downstream.
   - Decision docs (ADRs, `CONTEXT.md`, `DESIGN.md`) the change might contradict.
4. **Be honest about each risk.** Give it a real likelihood and a real cost. Separate confirmed risks from ones you checked and cleared. Cite real lines. A search that finds nothing is still an answer. Never invent a caller or an API.
5. **Prove the one fact.** Write the script or test, run it locally (never against live systems), and keep the output.

## Report

- **What it does.** What changed, including the non-obvious part.
- **The fact it's safe because of.** Stated, with the ladder step you reached and the proof. If you couldn't prove it, say "unproven".
- **Risks.** How each one breaks, `file:line`, likelihood and cost, and plain-language steps to reproduce it.
- **Cleared.** What you checked and why it's fine.
- **Before merging.** The cheapest test or repro that would catch the real bug, including any script you wrote.

If the report is long or has several findings, deliver it as an HTML page per [../work-with-me/references/rich-reports.md](../work-with-me/references/rich-reports.md), with a short summary in chat.
