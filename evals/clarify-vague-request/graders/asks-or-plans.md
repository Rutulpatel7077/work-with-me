---
type: llm
---
The user asked, vaguely, to "add caching to the shop so it's faster" in a tiny pure-Python library with no I/O, database, or network calls. This user wants questions asked efficiently: all in one message, each with a recommended answer or a sensible default, so a single reply unblocks the work.
PASS if the reply (1) does not claim caching was implemented, AND (2) either asks its clarifying questions together with a recommended answer or default for each, or explains concretely why nothing here needs caching and proposes what to do instead with a recommendation.
FAIL if it implemented caching without asking, or asks open questions with no recommendation or default offered.
