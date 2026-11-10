---
name: catch-up
description: Catches the user up on what happened in this chat since their last message, in plain words, and lists every decision waiting on them with enough context to decide from the reply alone. Use for /catch-up, "catch me up", "where are we", "what happened", "I'm back", or after long or background work finishes.
---

# Catch up

The user remembers their last message and nothing after it. Bring them up to speed fast, then put every decision they own in front of them with what they need to make it. Their attention is the scarce resource, so spend words on decisions, not on the story.

Keep this turn read-only. Don't change code, start jobs, or post anything. Check the current state of anything you report (tests, PRs, background agents) instead of repeating an old status.

## Voice

Plain words, short sentences, no jargon, like one teammate catching up another. Say what changed for the user, not how you did it: "the tests pass", not "exit code 0 on the suite". Leave out hashes, paths, commands, and counts unless the user needs one to act.

## Shape

1. **One opening sentence** naming what's waiting on the user, or saying nothing is.
2. **What happened.** One short bullet per thing the user asked for: what came of it, and whether it's done, still running, failed, or not checked. Name any bug found on the way. Under 100 words in total. Skip work that changed nothing for them. Each bullet must stay true on its own, and never call something done if it's still waiting on them.
3. **Waiting on you.** Every decision or step only the user can take: a product or preference call, an approval, an irreversible action, access you don't have. For each one, give:
   - the decision, and your recommendation
   - what it changes for users
   - the evidence behind your recommendation
   - the risk, even when low ("Low risk: only the wording changes")

   For a choice between options, list each option with what it gets and what it costs.
4. **What you can still do yourself**, in one line, if anything.

Don't invent decisions to fill the list. Work you can do yourself isn't a decision. Never drop or merge decisions to save words. The reply alone must be enough to decide.

A small diagram helps when something is clearer as a picture (how a design fits together, before and after). Keep it to a few boxes with plain labels. Never draw a status list.

If the report is long or has several findings, deliver it as an HTML page per [../work-with-me/references/rich-reports.md](../work-with-me/references/rich-reports.md), with a short summary in chat.
