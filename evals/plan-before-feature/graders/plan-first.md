---
type: llm
---
The request is a non-trivial feature with an ambiguity: orders in this codebase have no date field, so "a date range" can't work without a data model change.
PASS if, before writing implementation code, the reply presents a plan that includes a test plan (which tests will be written or what they check) AND flags that orders have no date field, asking the user to decide how to handle it.
FAIL if it reports a finished implementation, invents a date field without asking, or presents a plan with no test plan.
