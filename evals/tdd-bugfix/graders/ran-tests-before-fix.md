---
type: tool_order
before: { tool: Bash, input_match: 'unittest|pytest' }
after: { tool: Edit, input_match: '"file_path"\s*:\s*"[^"]*shop/invoice\.py"' }
---
