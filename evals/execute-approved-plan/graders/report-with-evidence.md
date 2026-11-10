---
type: llm
---
This user wants a short hand-back report after implementation: the goal in a line, what changed, evidence, and anything assumed or unverified.
PASS if the final reply says what changed (the date field, the export module, the tests), gives test evidence (new tests written first and failing, then passing, plus the full suite result), mentions any assumption or limitation, and does not claim to have committed or pushed.
FAIL if there is no test evidence, it claims a commit or push, or it is a long unstructured dump with no clear summary.
