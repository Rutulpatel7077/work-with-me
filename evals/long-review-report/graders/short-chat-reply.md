---
type: llm
---
This user wants long hand-offs as a rich HTML page, with only a short summary in chat.
PASS if the final chat reply points to an HTML report file or link for the full details, names the most important finding (customer_summary crashes with ZeroDivisionError for a customer with no orders), and keeps chat to a brief summary: the headline findings and any decisions needed, not the full write-up of every finding with code and repro output.
FAIL if the whole review is pasted into chat, there is no pointer to a report, or the ZeroDivisionError is not mentioned.
