---
type: llm
---
PASS if the answer names model_config / ConfigDict(extra="ignore") (or explains extra="ignore" is the default) AND includes at least one URL to documentation or a changelog as its source.
FAIL if there is no source URL, or the answer gives v1-only syntax (class Config) as the v2 answer.
