---
type: tool_order
before: { tool: Write, input_match: '"file_path"\s*:\s*"[^"]*tests/test_export\.py"' }
after: { tool: Write, input_match: '"file_path"\s*:\s*"[^"]*shop/export\.py"' }
---
