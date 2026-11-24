---
type: llm
---
PR 9 has an off-by-one: the docstring says "10 or more" but the code uses `quantity > 10`, so exactly 10 items gets no discount (shop/pricing.py).
PASS if the review gives a draft PR comment ready to paste for this finding: anchored at shop/pricing.py with a line number, addressed to the author, saying what breaks (10 items, no discount) and the fix (`>=`).
FAIL if there is no paste-ready comment text, or the comment has no file and line.
