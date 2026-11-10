# Models per role

Edit this file to change which model each role uses. Values are the aliases the Agent tool accepts: `opus`, `sonnet`, `haiku`, `fable`. `inherit` means the main chat's model (omit `model` on the Agent call).

| Role | Model | Used for |
| --- | --- | --- |
| code worker | sonnet | Implementing changes with `wwm-worker` |
| hardest code | opus | Cross-cutting changes, concurrency, subtle algorithms |
| researcher | sonnet | Multi-source research with `wwm-researcher` |
| judgment and prose | opus | Reviews, summaries, plans |
| arena runners | opus, sonnet | One runner per entry. Add entries for more runners |
| arena judge | opus, sonnet, fable | First entry that differs from the main chat's model |
| deep review adversaries | opus, sonnet | One adversary per entry, for review deep mode |
| reflect reviewers | opus | All three reflect lenses |
| explain explorers | sonnet | Read-only explorers for the explain skill, with `wwm-explorer` |
| verifier | sonnet | Fresh-eyes checks with `wwm-verifier` |

## Limits

| Setting | Value | Meaning |
| --- | --- | --- |
| max agents per fan-out | 5 | The most agents any one skill starts at once. Say the count and models to the user before starting more than 2 |

Each agent's turn cap is set in its own file under `agents/` (`maxTurns`). For headless runs (`claude -p`), always pass `--max-budget-usd`. It's the only hard spending cap, and it counts subagents.

If a model isn't available on this account, fall back to `inherit` and say so.
