---
type: regex
target: { source: file, path: shop/invoice.py }
pattern: 'if (not )?customer_orders|len\(customer_orders\)\s*(==|>|else)|else 0'
---
