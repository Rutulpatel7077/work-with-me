---
type: regex
target: { source: file, path: shop/report.py }
pattern: '#\s*(print|return|for |def |old_)'
match: not_contains
---
