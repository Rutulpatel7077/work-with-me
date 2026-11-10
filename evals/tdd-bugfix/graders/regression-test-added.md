---
type: regex
target: { source: file, path: tests/test_invoice.py }
pattern: 'customer_summary\(\s*["\x27][a-z]+["\x27]\s*,\s*\[\s*\]|no_orders|without_orders|zero_orders|empty'
flags: i
---
