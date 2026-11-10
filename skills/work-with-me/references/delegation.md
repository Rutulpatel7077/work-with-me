# Subagents and delegation

## When a subagent earns its cost

Each subagent sends its own requests on top of the main conversation. Multi-agent work uses many times the tokens of a single agent, so spawn only when it buys something the main thread can't:

- **Parallel independent work.** Separate files or questions that don't depend on each other.
- **Protecting context.** Broad searches or large reads where you only need the conclusion.
- **Independent opinions.** Reviews and verification where you want a read not anchored on yours.

## Sizing

| Task | Agents |
| --- | --- |
| A fact or a lookup in a few files | None. Do it yourself. |
| A comparison, or a focused investigation | 1 to 3 |
| A large feature, explain, review deep, or arena | Up to the `max agents per fan-out` line in [models.md](models.md) |

Before any fan-out of more than two agents, tell the user in one line what you're about to spend ("starting 4 explorers on sonnet and 1 synthesis on opus"), so they can cut it back. Launch the whole batch in one message, with briefs that share the same opening text.

## Briefing

Every brief gives the agent four things:

1. **Objective.** The user's goal and this agent's exact question.
2. **Output format.** What to return, in what shape, and a word limit.
3. **Tools and sources.** Where to look and what to use (files, docs, commands, the web).
4. **Boundaries.** What's in scope, what isn't, and what it must not do.

Add what you already know so it doesn't redo your work. Pick the model per [models.md](models.md).

## The bundled agents

| Agent | Use for | Limits |
| --- | --- | --- |
| `work-with-me:wwm-worker` | Carrying out a written plan or a delegated change | 60 turns, can't spawn agents |
| `work-with-me:wwm-researcher` | Multi-source research with a sourced answer | 30 turns, read and web only |
| `work-with-me:wwm-explorer` | Read-only investigation: explain explorers, reflect reviewers | 40 turns, read and search only |
| `work-with-me:wwm-verifier` | Fresh-eyes check of finished work before hand-back | 40 turns, can run commands, doesn't edit |

An agent that hits its turn limit returns a partial result. Resume it if the remaining work is worth it, or finish the rest yourself.

## Delegating a code change

Do the thinking, delegate the typing. Understanding the code, deciding what to do, and writing the spec is where a strong model pays off. Following a precise spec is where a cheaper one does fine. Never spawn workers before the overall plan exists and the user has approved it where [planning.md](planning.md) says they should.

1. **Write the unit's spec** with [plan-template.md](plan-template.md), from your own reads of the code. Skip the full template for a change small enough to describe exactly in a few lines, but keep its three parts: the exact change, the verification command, and the STOP conditions.
2. **Hand it over.** Spawn `work-with-me:wwm-worker` with the full spec inlined in the prompt, never a path to an uncommitted file. Use `isolation: "worktree"` when several workers run at once or the change is risky. A worktree only contains committed files, so inline anything else it needs.
3. **Review like a tech lead.** Never trust the report on its own:
   - Re-run every "done when" check yourself.
   - Compare `git diff --stat` (with `git -C <worktree>` for a worktree) against the in-scope list. A change outside scope fails review.
   - Read the whole diff against the spec's "Why". Does it solve the actual problem, the way the rest of the codebase would?
   - Read what the new tests assert. A test that asserts nothing meaningful passes and proves nothing.
   - Judge a documented deviation on its merits. An undocumented one is a failure.
4. **Verdict.** Approve and hand back to the user (never merge or commit for them). Send back with specific fixes, at most twice. Or stop, rewrite the spec with what you learned, and tell the user what changed.
