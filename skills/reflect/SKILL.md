---
name: reflect
description: Learns from the current session. Reviewers mine the conversation for mistakes, corrections, and repeated friction, and turn the durable lessons into proposed edits to the work-with-me skills, the project's CLAUDE.md, or a hook or test. Nothing is applied without the user's approval. Use for /reflect, "reflect", "learn from this", "remember this for next time", or "what should we improve".
disable-model-invocation: true
---

# Reflect

Turn what went wrong or right in this session into a lasting change, so the user doesn't have to correct the same thing twice. Skip it when the session was trivial or everything followed the skills already. A one-off isn't a lesson.

Track the steps in a todo list: Locate, Review, Synthesize, Approve, Apply.

## 1. Locate

- **The transcript.** Claude Code keeps it at `~/.claude/projects/<project-path-with-slashes-as-dashes>/<session-id>.jsonl`. List that one project folder by modification time and take the newest file whose early user messages match this conversation's opening request. Never read other projects' folders, they hold unrelated private chats. If you can't find it, write a tight digest of the session instead.
- **The editable plugin source.** Never edit the installed copy under `~/.claude/plugins/`, it gets overwritten on update. Find the user's git checkout of `work-with-me`: look for a folder containing `.claude-plugin/plugin.json` with `"name": "work-with-me"` in the current directory and in the usual code folders (`~/dev`, `~/code`, `~/src`, `~/projects`). If there isn't one, offer to clone it with `gh repo clone <owner>/work-with-me`, taking the owner from the marketplace source.

## 2. Review

Tell the user in one line that you're starting three reviewers and on which model.

Spawn three reviewers in one message, in the background, using the `work-with-me:wwm-explorer` agent (read-only), each on the model from the `reflect reviewers` line in [../work-with-me/references/models.md](../work-with-me/references/models.md). Give each the transcript path (or digest), the plugin checkout path, and its lens from [references/reviewers.md](references/reviewers.md), with the shared rules at the top of that file. If the user asked a question when starting reflect, pass it to the reviewers as a question. Don't tell them the answer or the edit you expect.

| Lens | Looks for |
| --- | --- |
| Judgment | Mistakes, the user's corrections and preferences, decisions and their reasons |
| Tooling | Commands, flags, config, and project facts the agent had to rediscover, and context the user handed over that the agent could have fetched itself |
| Divergent | What the other two will miss: skipped verification, lucky passes, second-order effects, skills that should have fired and didn't |

## 3. Synthesize

Do this yourself once all three return. Read each target file before judging a finding. Apply [references/synthesis.md](references/synthesis.md) to every finding and sort it into Accepted, Structural, or Rejected.

## 4. Approve

Show the user the full result in this shape, then stop and wait:

**Accepted.** A table with one row per edit: Problem, Proposal, Where (the file and section).

**Structural.** Lessons better enforced by a hook, script, lint, or test than by more text, with the mechanism you'd build.

**Rejected.** One line each with the reason.

The user picks which rows to apply and may redirect any of them. When there are more than a few rows, present them as an HTML page per [../work-with-me/references/rich-reports.md](../work-with-me/references/rich-reports.md). Never apply anything unapproved. These files shape every future session on every device.

## 5. Apply

- Make each approved edit in the plugin checkout, or the project's `CLAUDE.md` for repo-specific facts. Keep each edit the smallest wording that changes behavior. If guidance exists but didn't fire, strengthen or move it instead of adding a duplicate.
- For approved structural items, build the hook, script, or test test-first with the **tdd** skill.
- For each approved behavior lesson, add an eval case under `evals/` in the plugin checkout that would have caught it: copy the closest existing case, change the prompt, the setup script, and the graders. Prefer exact graders (`tool_used`, `tool_order`, `regex`) over judge rubrics. Then run just that case with `claude plugin eval . --scaffold --trust-plugin --runs 3 --case <name> --allow-tools Write Edit Bash`, and report its score with and without the plugin.
- Run `bash tests/run.sh` in the plugin checkout.
- Don't commit or push unless the user asks. Hand back with one line per change: the file and what changed. Remind the user that other devices need a push, then `claude plugin marketplace update work-with-me`.
