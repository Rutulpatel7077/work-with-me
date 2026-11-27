# What reviewers catch: checks keyed to the diff

Loaded by the review skill's step 3. Each check names something the diff does and what to look at. They come from about 700 human review comments that led to a fix, across four codebases written mostly in TypeScript. Most need a grep outside the diff, which is why reading the diff alone misses them.

Go through the groups the diff touches and skip the rest. A check that fires is a candidate, not a finding: it still goes through step 4.

## Rules and sets

- **A second copy of a rule.** When the diff adds a predicate, parser, normalizer, limit, or allowed list, grep for one that already answers the same question (membership, eligibility, entitlement, a flag parse). Reuse it, or run both on the same inputs (case, unknown values, a user in two groups) and report where they disagree. Two copies of a business rule are a drift bug, not clutter. Not a finding when the two serve different purposes on purpose.
- **A new member of a closed set.** When the diff adds an enum value, status, type, or column, grep every switch, map, query, and validator over that set. Each one handles the new member or fails loudly in its default.
- **Copies inside the diff.** Near-identical blocks per product or service, repeated query fragments, or two structures that must list the same keys: ask for one table or shared piece that drives them all. A "keep in sync with X" comment is the trigger. An import, or a type that breaks the build on drift, replaces it. Not when each copy would need a flag per difference.
- **A fix at one site.** When the diff fixes or guards one call site, grep its siblings for the same flaw. When it adds a shared helper, check every old copy now uses it.
- **Text matching.** For `includes`, a regex, slugs, or equality on normalized values, try lookalike inputs: one name inside another, case and punctuation variants, line breaks against `.` and `$`, and both sides normalized the same way.
- **One limit, two sides.** When server and client enforce the same size or count limit, it comes from one constant, or a test asserts the two agree.

## Async and state

- **A result that lands late.** For each async result written to state (a fetch, stream, subscription, job), ask what happens when the selection changes, the user cancels, or the client disconnects before it settles. The abort reaches the real call, the write checks it is still the current request, a late callback can't bring back cleared state, and a restarted loop can't run beside the stale one. A finding here names the interleaving: which result lands after which change.
- **An action that can fire twice.** For a button, a submit, an endpoint that starts a job, a read-then-insert, or a cache-miss regenerate, name what stops the second one: a synchronous lock (a state flag lags a tick), a unique constraint, an idempotency key, or a re-read after taking the lock.
- **Failure mirrors success.** For each thing the success path sets (a status, a loading flag, a run-once marker, a dedupe id, a metric), check the failure path resets or records it. Otherwise a failure leaves a stuck spinner, a blocked retry, or a job falsely marked done. A "done" marker is set only after the effect succeeds.
- **Waits without a limit.** Every poll, retry, reconnect, and long loop has a maximum count or time. Retry counters reset after a success. Loops and timers stop on shutdown.
- **A failure shown as empty.** A failed request renders an error with a way out, not an empty list or a blank page. A failed refetch doesn't overwrite good data. A null or failed result isn't cached for the full lifetime of a good one.
- **Fallbacks.** For each new default (`??`, `||`, a looser lookup), ask whether the placeholder (0, an empty string) can pass a check meant for real data, and whether a generic fallback mislabels a specific field. Test booleans and nullable fields as true, false, and absent.

## Data, config, and rollout

- **Data written under the old rule.** When the diff tightens a validator, changes a stored shape or default, or adds a cap, check existing rows, older clients, and values from other services against the new rule. A stricter validator is a data migration. A backfill's filter must match the runtime predicate. Prefer degrading the one bad item over rejecting the whole record.
- **Config is code.** A config-only diff is not a low-risk diff. For each env var or default the diff reads or adds, resolve it per environment: unset, set but blank, and production. A default must not point at a shared or real resource. Read the code that consumes each changed value.
- **A mechanism moved.** When secret loading, a build step, a wrapper command, or provisioning changes, grep every script, compose file, CI job, and manifest that used the old way. A route added behind path-list middleware is in the list.
- **Error status matches the cause.** A conflict, duplicate, or validation error is a 4xx through the project's error type, and a server failure still reaches 5xx alerting. A new guard isn't pre-empted by an earlier check with a misleading message.
- **A flag is the rollback lever.** Its off path is the code on the main branch today. Don't ask to remove a flag kept as a kill switch.

## Security

Still check for committed secrets and injection. These three are what reviewers caught far more often.

- **Authorization against siblings.** When the diff adds or changes a route, query, or gate, compare its checks with sibling routes on the same resource: a write is never weaker than a read. A by-id query also filters by the owning tenant or user in the query itself. When access is revoked, the rows and permissions that access created are removed too. Ask for a test that fails when the gate's condition is inverted.
- **What leaves through logs and errors.** For each new log call, catch block, and user-facing error, check what it can carry: a raw client error with auth headers or a request body, upstream exception text, a "not found" that reveals whether an id exists, personal data. Where a comment says "we never log X", trace the error paths too.
- **Untrusted files, URLs, and names.** A URL from a request gets an allowlist before it is fetched. A file gets size and type limits before it is read into memory. A filename is restricted before it reaches a path or a header. A regex with nested quantifiers doesn't run on user text.

## Docs and claims

- **Claims are assertions.** Every claim in a new or changed comment, docstring, or the PR description ("idempotent", "atomic", "never logs X", "restricted to Y", "uses the index", "matches the server rule") is checked against the statement that implements it. A comment that is wrong is worse than none, because the next reader trusts it.
- **Docs in the same diff.** When a path, command, route, status code, or label changes, grep the old name in READMEs, agent and contributor guides, API specs, example collections, and end-to-end selectors. Every command, env var, and route the docs name exists in the code.
- **Orphans.** When the diff removes the last caller of something, grep for it outside the diff, and delete the helper, its tests, the state that supported it, and lint suppressions it needed. Not when it is public API, or a building block for a follow-up the PR names.
- **References a reader can't follow.** Comments citing plan ids, acceptance-criteria numbers, or design docs that aren't in the repo.

## Cost

- **Grows without a bound.** Anything keyed or sized by caller input (a map, a queue, an option list, a file read whole) has a limit or eviction.
- **One query per item.** A loop or `Promise.all` issuing a query or write per row should batch. A transaction doesn't stay open across a slow external call. A best-effort side effect isn't awaited on the response path.
- **Work nobody needs.** A shared layout or provider that fetches for one feature skips it when the feature is off or hidden.

## Logging

An error is logged once, not at both the client and the handler. A failure the caller caused is a warning, not an error. A silent degrade (an unknown value treated as not found, dropped input) leaves a log line that can be traced.

## By stack

Apply only what matches the diff's languages.

- **TypeScript.** External, stored, or server data narrowed with `as` (including a function named `parse` or `validate` that only casts) is parsed with a schema at the boundary. A string field with known values is a literal union, and a switch over it has a default that fails on an unhandled member.
- **React.** A prop copied into state re-syncs when the parent changes it. Drawer or sheet state is keyed by the selected item. The active item is tracked by id, not index. A state update from the previous value uses the functional form. No side effects or storage writes during render or inside an updater. A ref updated in an effect reads stale in earlier effects.
- **Swapped components.** When a component, form control, or library is replaced, list what the old one did that no caller wrote down (stopping click propagation, when its error renders, `type` and `min` attributes, forwarded test ids) and confirm the new one does each. The lost behavior is inside the old implementation, not in the `-` lines.
- **Events and markup.** A row click against the controls inside it. An Escape handler that stops the event before the dialog's own listener sees it. Enter getting past a disabled button. No interactive or block elements inside a `<label>`. Focus kept when a control disables itself. An `aria-label` that contains the visible text.
- **SQL.** `ORDER BY` with a limit or paging has a unique tie-breaker. A `WHERE` on a left-joined table drops the unmatched rows. A "not exists" expiry check must not treat a missing row as active forever. A new predicate has an index behind it.
- **Node.** Every event-emitting connection has an error handler. Resources are closed in separate `try` blocks. A shared error writer checks whether headers were already sent.
