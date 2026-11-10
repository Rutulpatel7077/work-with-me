---
type: regex
target: { source: file, path: shop/export.py }
pattern: '#\s*(Loop|Iterate|Return the|Initialize|Import|Create a|Write the|Add the|=====|Calculate the)'
flags: i
match: not_contains
---
