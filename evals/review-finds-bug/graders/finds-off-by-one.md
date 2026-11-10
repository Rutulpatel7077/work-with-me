---
type: llm
---
The branch adds a bulk discount whose docstring says it applies to "10 or more" of an item, but the code uses `quantity > 10`, so exactly 10 items gets no discount.
PASS if the review reports this off-by-one (10 items not discounted / > should be >=) AND gives concrete steps or a test/command to reproduce it.
FAIL if the review misses it or gives no way to reproduce it.
