# Planning before code

Most bad outcomes start with a weak plan, not weak typing. The main agent (the strongest model in the session) does the thinking: understanding, researching, deciding, and planning. Cheaper agents carry out well-specified pieces. Nobody writes code until the plan is good and everything it needs is in hand.

## When to plan

- **Plan, and show it to the user before any code,** when the work touches several files or modules, changes behavior users will notice, adds a feature or a data model, makes an architectural choice, touches anything risky or hard to undo, or will be split across subagents.
- **Plan in a few lines and go,** for a small, clear change: a bug with an obvious fix, a rename, a contained edit. Say the plan in one or two sentences in your reply and start.
- **Run the arena** instead of a solo plan when the design has real alternatives and a wrong shape would be costly. Offer it to the user first. It spends several agents.

## What the plan covers

Keep it as short as the work allows. Drop sections that don't apply.

1. **Goal.** One or two sentences in your own words, plus what "done" looks like.
2. **Approach.** The shape of the solution: data shapes first, which modules change or get added, and why this approach over the obvious alternative.
3. **Research.** What you already confirmed (versions, docs, APIs, with sources), and anything still to look up before or during the work. Unknowns that could change the approach get researched *before* the plan is shown, not after.
4. **Test plan.** Which tests to write first and what each proves, where they go, which existing test to copy the pattern from, and the exact command to run them. For behavior you can't test cheaply, the check you'll use instead.
5. **Steps.** Small units, each ending in a check. Mark which can run in parallel, which depend on others, and who does each one (you, or a delegate on which model). Delegated units get a full spec from [plan-template.md](plan-template.md).
6. **Readiness.** Confirm you have what execution needs, so nothing stalls halfway:
   - the build, test, and lint commands, run once and working
   - the tools, CLIs, MCP servers, and access required (say exactly what's missing and how to get it)
   - the information only the user has (product decisions, credentials, which environment)
   - the research that could change the approach, done
7. **Risks and open questions.** What could go wrong, what you assumed, and every decision that needs the user, each with your recommended answer.

## Review with the user

- Present the plan concisely. If it's long or has several decisions, use an HTML page per [rich-reports.md](rich-reports.md), with the decisions and your recommendations at the top.
- Ask everything you need in one message. Don't drip questions.
- Wait for the go-ahead before writing code on work that met the "show it first" bar. If the user already said to proceed, or the plan has no open decisions and nothing risky, say "starting now" and go. They can still stop you.
- If the user changes the plan, update it before executing. Don't carry two versions in your head.

## Executing the plan

- Work through the steps in order, each one test-first, checking each before the next.
- Hand delegated units to cheaper agents per "Delegating a code change" in [delegation.md](delegation.md): a full spec, then a tech-lead review of what comes back.
- If reality contradicts the plan (a test fails for an unexpected reason, an assumption turns out false, a step needs something unplanned), stop and re-plan that part. Tell the user if it changes the approach, scope, or risk. Don't quietly improvise around it.
- For plans longer than a few steps, track progress so it survives a long session or a new one: a short checklist of the steps and their checks, kept outside the repo or gitignored.
