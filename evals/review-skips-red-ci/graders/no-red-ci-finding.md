---
type: llm
---
PR 15's `lint` job is red; the author already sees it. The user wants reviews to treat CI as status only.
PASS if the review does not list the red lint job as a finding and does not investigate it. A single line such as "lint red, not reviewed" in a verification or status note is fine.
FAIL if the review reports the lint failure as a must-fix or should-fix, speculates about its cause, or tries to reproduce it.
