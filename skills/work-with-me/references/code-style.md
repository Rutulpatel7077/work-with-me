# Code style

Code should read like a story. A reader starts at the top of a file and understands it by reading down, without jumping around. Use this guide when writing code and when reviewing it. Where the project already has its own conventions, follow those first.

## Data shape first

Before writing logic, name the core data: the types, records, and structures the feature works with, and how each is read and written. Get that right and the code around it becomes obvious. Get it wrong and every function compensates. When code branches a lot on the same condition, the shape is usually missing a type, a state, or a lookup table.

## Read top to bottom

- Put the main entry point or the public function first, then the helpers it calls, in the order it calls them. The reader meets the big picture before the details.
- Each function tells one step of the story at one level of detail. A function that orchestrates calls named steps. It doesn't mix in low-level string parsing halfway through.
- Name functions and variables for what they mean in the domain (`unpaidInvoices`, `sendReminder`), not how they work (`filteredList`, `processData`).
- Prefer early returns over nested `if` blocks. The happy path reads straight down the left margin.
- Keep related code close together. A reader shouldn't have to scroll past unrelated code to follow one flow.

## One module, one job

- Each module (file, folder, or package) owns one concern: one feature, one integration, one data model. You can describe it in one sentence without "and".
- A new feature goes in its own module. It doesn't get sprinkled across several unrelated files.
- Keep layers apart. Input parsing and validation at the edges, business logic in the middle, I/O (database, network, filesystem) behind a clear boundary. Business logic doesn't reach into HTTP requests or SQL strings.
- **Validate at the boundary, trust inside.** Check and parse external input (CLI args, config, API responses, user input) once, where it enters, into proper domain types. Code inside trusts those types and doesn't re-check them. Business logic is pure functions the thin outer shell calls, so it tests without the framework.
- Modules talk through a small, explicit interface. Callers shouldn't need to know a module's internals.
- Don't create a file or abstraction for something with one tiny caller. Split when a module starts doing two jobs, not before.

## Keep it simple

- **Subtract before you add.** Before building on existing code, remove the dead code, unused options, and redundant checks in the way. Then build on the simpler base. Leave each area a little simpler than you found it.
- The smallest change that solves the problem. No speculative options, flags, or layers "for later".
- Reuse what the codebase already has before writing something new.
- Plain code over clever code. If a one-liner needs a second read, write three clear lines instead.
- Delete dead code, unused parameters, and commented-out blocks rather than leaving them.
- Comment only a non-obvious *why*, in one plain sentence. Good names cover the *what*. The **unslop** skill lists what to keep and what to delete.

## Easy to change

- A change to one behavior should touch one module. If a small change needs edits across many files, the concerns are mixed. Say so.
- Keep state local and short-lived. Avoid globals and shared mutable state.
- Tests describe behavior through the module's public interface, so internals can be refactored without rewriting tests.
