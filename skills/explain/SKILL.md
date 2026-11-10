---
name: explain
description: Explains how a feature or subsystem works from start to finish, like one developer briefing another. Fans out read-only agents to investigate each part, checks every claim against the code, and delivers a short, scannable HTML report covering entry points, the main flow, what it depends on, and where data is stored. Use for "explain X", "how does X work", "walk me through X", "help me understand X", onboarding onto unfamiliar code, or before changing a large feature.
argument-hint: [feature or subsystem]
---

# Explain

Produce the briefing a senior developer would give a colleague who's about to work on this feature: what it does, how a request moves through it from start to finish, what it needs, where its data lives, and what will bite them. Short, accurate, and every claim tied to a real line of code.

You document what is, not what should be. Save opinions for the Gotchas section, and keep those factual.

Track the steps in a todo list: Scope, Locate, Investigate, Synthesize, Verify, Write.

## 1. Scope

- Restate what you'll explain in one sentence. If the feature name could mean several things, pick the likeliest, say which, and continue. The user can redirect.
- Record the commit (`git rev-parse --short HEAD`) and branch. The report describes the code at that commit.
- Skim the README, `CLAUDE.md` or `AGENTS.md`, any glossary or `CONTEXT.md`, `DESIGN.md`, architecture docs, and ADRs. Use the project's own names for things throughout, and pass the decisions they record to the explorers so a deliberate choice isn't reported as a gotcha.

## 2. Locate

Find where the feature lives before deciding how to split the work. Search for its names, routes, commands, job names, event names, and UI labels. Look for entry points in config as well as code: route tables, dependency injection, job schedulers, CLI registrations, deployment config.

Size it:

- **Small** (a handful of files, one clear path): skip the fan-out. Investigate it yourself using the explorer brief as your checklist, then go to step 4.
- **Large** (many files, several layers or services): fan out in step 3.

## 3. Investigate

Split by question, not by directory. Pick the angles this feature needs, usually 3 to 5:

| Angle | Answers |
| --- | --- |
| Entry points | What starts it: HTTP routes, UI actions, CLI commands, jobs, events, webhooks |
| Main flow | What happens step by step from the trigger to the final effect, and how the data changes along the way |
| Data and state | Where it reads and writes: tables, caches, files, queues, external stores, and which code does each read and write |
| Dependencies and config | Internal modules, external services and libraries, environment variables, feature flags |
| Errors, edges, and tests | Failure paths, retries, limits, and what the tests cover |

For a very large feature, add one explorer per subsystem as well.

Before spawning, tell the user in one line how many explorers you're starting and on which model. Spawn all explorers in one message, in the background, with the `work-with-me:wwm-explorer` agent (read-only), on the model from the `explain explorers` line in [../work-with-me/references/models.md](../work-with-me/references/models.md). Give each one the brief in [references/explorer-brief.md](references/explorer-brief.md), with its angle, the feature, the vocabulary, and the starting files from step 2.

## 4. Synthesize

- **Read the key files yourself.** Every explorer returns a short list of must-read files. Read them before writing. Summaries of summaries drift.
- **Reconcile.** Where explorers overlap, merge. Where they disagree, check the code and go with what it says.
- **Fill gaps once.** If an important question is still open, run one targeted follow-up (yourself or one more explorer). Whatever is still unknown after that goes in Open questions.

## 5. Verify

- Run the citation check on your draft: `bash <this skill's folder>/scripts/check-citations.sh <report.html> <repo root>`. Fix or remove every broken citation.
- Spot-check the claims the explanation rests on, especially every data read and write and every arrow in a diagram. An arrow is a claim. Only draw an edge you saw in code.
- Mark anything you couldn't confirm as unconfirmed, next to the claim.

## 6. Write

Build the HTML report from [../work-with-me/assets/report-template.html](../work-with-me/assets/report-template.html), following [references/report-outline.md](references/report-outline.md). Deliver it per [../work-with-me/references/rich-reports.md](../work-with-me/references/rich-reports.md): publish or open the page, and give a three-to-five-line summary in chat with the link.

**Done when:** every section in the outline is either filled from evidence or deliberately dropped, the citation check passes, and every diagram explains something the prose alone would explain worse.
