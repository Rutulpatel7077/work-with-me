# Rich reports

When you hand something to the user to review, check, or decide, and it's too much to read comfortably in chat, put it in an HTML page instead of a long Markdown reply. A well-laid-out page is faster to take in, and the user's attention is the scarce resource.

## When to use a page

Use a page when the hand-off has any of:

- More than about one screen of content (roughly 40 lines of Markdown).
- Several findings, decisions, or options to compare (a review with many findings, a catch-up with several decisions, reflect's proposed edits, an arena plan comparison).
- Something clearer as a picture: an architecture or data-flow diagram, before and after, a timeline, a table to scan.

Keep short answers in chat. A page for three lines is noise.

## How to deliver it

1. **Publish or open it.** If an artifact or page-publishing tool is available (such as Claude Code's Artifact tool), publish it there. Pages start private, and the user gets a link they can share. Otherwise write one self-contained `.html` file outside the project: the session scratchpad if the system prompt lists one, else `$TMPDIR` (or `/tmp`). If a write there is refused, try the other location before giving up, and only fall back to chat when neither works. Open it with `open <file>` on macOS or `xdg-open <file>` on Linux. Never write report pages into the repo unless asked.
2. **Still reply in chat**, briefly: one or two sentences on the outcome, any decision that blocks you, and the link or file path. The user should know what's waiting on them without opening the page.

## How to build it

Start from [../assets/report-template.html](../assets/report-template.html). It has the styling, light and dark themes, and building blocks (TL;DR box, cards, badges, numbered steps, collapsible details, optional Mermaid diagrams) ready to fill in.

- **One self-contained file.** Inline CSS and JS. No external requests except a pinned library from a public CDN when it earns its place, such as a diagram library.
- **Readable in light and dark.** Define colors as CSS variables and switch them with `prefers-color-scheme`. Use a system font stack, comfortable line length, and real headings.
- **Lead with what matters.** At the top: the verdict or outcome, then what's waiting on the user with your recommendation for each. Details below.
- **Make it scannable.** Severity badges, collapsible sections (`<details>`) for long evidence, tables for comparisons, code blocks for commands and output.
- **Diagrams only when they explain.** Draw one the way a senior engineer reaches for the whiteboard: when the words start getting tangled. That usually means three or more parts talking to each other, data changing shape across stages, a branching flow, or a before and after. If a few sentences or a numbered list say it clearly, don't draw anything. Never draw a diagram to decorate a page, restate a list, or show a single step. Every diagram must answer a question the prose would answer worse, and the text around it says what to notice. Keep each one small (about eight boxes at most, short labels). Split a big system into a few small diagrams rather than one wall of boxes.
- **Make actions easy.** Each finding or decision shows the file and line, plain-language reproduction steps, and the exact command to run, ready to copy.
- **Accurate only.** Every number, quote, and output comes from what you actually ran or read. Never invent a screenshot, link, or result.
- **Mind sensitive content.** Leave out secrets, tokens, and credentials. Private code is fine in a private page or local file. Ask before putting it anywhere others can see.
