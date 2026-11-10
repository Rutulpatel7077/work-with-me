---
name: research
description: Looks things up in current docs, changelogs, and installed source instead of answering from training data. Use before answering or coding against any third-party library, framework, SDK, CLI, API, or cloud service, and for anything new, latest, version-specific, or time-sensitive (releases, pricing, limits, deprecations). Also use when a dependency error message is unfamiliar.
argument-hint: [library, API, or question]
---

# Research before answering

Training data goes stale. Docs, APIs, and defaults change between versions. A confident answer from memory that turns out outdated costs the user more than a minute of looking it up.

## Steps

1. **Find the version in use.** Check the lockfile or manifest (`package-lock.json`, `pnpm-lock.yaml`, `poetry.lock`, `go.mod`, `Cargo.lock`, `Gemfile.lock`), or run the tool's `--version`. Research that version, not the latest, unless the user is asking about upgrading.
2. **Check local sources first.** Installed package source and types (`node_modules/<pkg>`, site-packages), `--help` output, and the repo's own docs. These match the exact installed version.
3. **Go to primary sources.** Official docs, changelogs, release notes, migration guides, the project's GitHub repo and issues. Use whatever web tools are available (web search, web fetch, a docs MCP server, `gh` for GitHub). Prefer official sources over blog posts and Q&A sites.
4. **Keep it quick.** For a simple API question, one or two lookups is enough. Go deeper only when sources disagree or the stakes are high (migrations, security, data loss). For broad multi-source research, delegate to the `work-with-me:wwm-researcher` agent so the main thread keeps only the conclusion.
5. **Answer with sources.** Link the pages you read. Say which version they cover.

## If no web tool is available

Say so plainly: "I can't reach the web from here, so this is from training data as of my cutoff and may be stale." Name the tool that would fix it (a web search tool, a fetch tool, or `gh`). Then give your best answer, labeled as unverified.

## Rules

- Never invent a URL, version number, flag, or API. If you didn't read it this session, label it as recalled from memory.
- When docs and installed source disagree, trust the installed source for current behavior and mention the gap.
- When you find the answer changed recently (renamed API, new default, deprecation), call that out. It is often the thing the user needed most.
