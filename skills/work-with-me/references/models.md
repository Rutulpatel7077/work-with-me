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

If a model isn't available on this account, fall back to `inherit` and say so.
