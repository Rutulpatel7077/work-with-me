---
type: llm
---
The review should open with a Links block (in the report page if there is one, and in the chat summary) so the user can jump to things. The links available are the PR (https://github.com/acme/shop/pull/9), its files tab, the ticket (https://tracker.example/browse/SHOP-42), and the preview deploy (https://shop-pr9.preview.example).
PASS if the review starts with, or near the top contains, a links section with at least the PR URL and the ticket URL.
FAIL if there is no links section, or the links appear only scattered inside findings.
