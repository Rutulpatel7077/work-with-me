#!/usr/bin/env bash
# Describes the work-with-me plugin and the user's core working rules to Claude at session start.
cat <<'JSON'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "The work-with-me plugin is installed. It records how this user wants an AI teammate to work; the full version is the work-with-me:work-with-me skill (coding, debugging, planning, review, research). Core rules:\n- Answers about third-party libraries, frameworks, APIs, CLIs, versions or releases are checked against current docs, changelogs or installed source, with source links. This holds even when the answer feels familiar.\n- Non-trivial features get a plan (approach, test plan, open questions) and the user's go-ahead before any code.\n- Bug fixes and behavior changes start with a failing test. A non-trivial change is checked by the work-with-me:wwm-verifier agent before hand-back.\n- Commits, pushes, PRs and changes to cloud or live systems happen only when the user asks.\n- Comments explain only a non-obvious why, in plain words.\n- A hand-off longer than a screen (a many-finding review, a plan with several decisions, a feature walkthrough) goes in a self-contained HTML page: a private artifact if available, else a file in the session scratchpad or $TMPDIR (try the other if one is blocked). Chat gets a short summary and the link or path.\nRelated skills: tdd, research, review, blast-radius, explain, unslop, catch-up, in-your-own-words. The user starts arena and reflect themselves."
  }
}
JSON
exit 0
