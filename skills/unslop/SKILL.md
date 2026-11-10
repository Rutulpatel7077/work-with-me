---
name: unslop
description: Removes AI slop from code, comments, and written reports. Use while writing any code, as a cleanup pass on your own diff before handing work back, when reviewing code, or for "unslop", "clean this up", "too many comments", "this looks AI-generated". Keeps only comments that explain a non-obvious why, in plain language.
argument-hint: [files or diff]
---

# Unslop

Code should read like a careful human wrote it: no narration, no defensive clutter, no leftovers. Most AI slop is noise that makes the reader work harder for nothing. Remove it.

Use it two ways:

- **While writing.** Follow the rules below from the start. A cleanup pass after drafting catches less than writing clean in the first place.
- **As a pass on a diff.** Before handing work back, go through your own diff (`git diff`, including new files) with the checklists below. Fix what you find. When reviewing someone else's code, report it instead of fixing.

Only touch code inside the task's scope. Don't clean up unrelated files unless asked.

## Comments

Code says *what* and *how*. A comment earns its place only by saying *why*, when the code can't.

**Keep a comment when it explains:**
- A non-obvious reason: a workaround for a library bug, a platform quirk, a protocol or vendor requirement, a performance choice that looks wrong but isn't.
- A constraint the code can't express: "must run before the cache warms", "the API rejects more than 100 ids per call".
- A public API contract: doc comments on exported functions and types that other people call.
- A link to the issue, RFC, or ADR behind a decision.
- A license header, or a lint or type suppression together with its reason.

**Write kept comments simply.** One short line in plain language, if possible. Say why, not what. "Retry once because the payment API drops the first request after idle" beats "Implement robust retry mechanism to enhance reliability".

**Delete:**
- Narration of what the next line does: `// Loop through users`, `// Return the result`, `// Initialize variables`.
- Comments that restate the name or signature: a doc comment saying `getUser` "gets the user".
- Section banners and dividers: `// ===== HELPERS =====`.
- History and change notes: `// Updated to fix bug`, `// Changed from X to Y`, `// Added for the new feature`. That's what git is for.
- Commented-out code. Git keeps it.
- `TODO` without an owner or issue link, and "for now" or "temporary" notes with no plan.
- Notes to the reviewer or to yourself: `// This should work`, `// Note: I've made this more robust`.

**If the code needs a comment to be understood, try fixing the code first:** a better name, a smaller function, an explaining variable, a type. Comment only what's left.

## Code slop

Patterns AI-written code tends to have. Look for each one:

- **Defensive clutter.** Try/catch around code that can't throw, or that just logs and rethrows. Null checks on values the types or the boundary already guarantee. Re-validating data that was validated at the edge. Fallbacks for cases that can't happen.
- **Swallowed errors.** `catch (e) { console.log(e) }` or an empty catch on a real failure path. Either handle it or let it propagate.
- **Speculative generality.** Options, parameters, config flags, interfaces, or factories nobody asked for, "for future extensibility". Abstractions with one caller. Wrappers that only forward.
- **Leftovers.** Debug logs, `print` statements, unused imports, variables, parameters, and functions, dead branches, stray files, and test-only hacks in production code.
- **Generic names.** `data`, `result`, `item`, `temp`, `handleClick2`, `processData`, `utils`. Name what it is in the domain.
- **Reinvented helpers.** Hand-written versions of something the codebase or standard library already has.
- **Inconsistent style.** A new pattern for errors, logging, or data fetching when the repo already has one. Match the existing one.
- **Over-formatted output.** Emojis, decorative ASCII, and exclamation marks in logs, CLI output, or error messages.
- **Compatibility shims nobody needs.** Keeping the old function, re-exports, or `_unused` renames around when you could update the callers.
- **Noisy tests.** Tests that assert nothing meaningful, mock the thing under test, or repeat the same case with different names.

## Prose slop (reports, PR descriptions, docs, replies)

- Lead with the answer. No "Great question!", "I hope this helps", or "Let me know if…".
- Plain words: "use" not "leverage" or "utilize", "help" not "facilitate", "is" not "serves as".
- Cut filler: "in order to" → "to", "it's important to note that" → delete.
- Name the mechanism or the number instead of a feeling. "The query takes 40 ms" beats "the query is blazing fast".
- One idea per sentence. Active voice. Whole sentences, not arrow-and-symbol shorthand.
- No hype words (crucial, robust, seamless, pivotal, comprehensive), no decorative emojis, no needless bold.
- Don't hedge everything. Say what you know, and label what you don't.

## Report

After a cleanup pass, say in a line or two what you removed (counts are fine: "deleted 9 narrating comments, 2 unused imports, 1 swallowed error now propagates") and anything you left on purpose with its reason.
