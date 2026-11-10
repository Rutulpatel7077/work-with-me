---
type: regex
target: { source: file, path: shop/report.py }
pattern: '#\s*(Loop|Iterate|Return the|Initialize|Import|Calculate the|Create a|Add the|=====|Updated to|Increment)'
flags: i
match: not_contains
---
