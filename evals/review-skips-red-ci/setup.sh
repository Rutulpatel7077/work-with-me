#!/usr/bin/env bash
set -e
FIXTURES="$(cd "$(dirname "$0")/../_fixtures" && pwd)"
bash "$FIXTURES/shop/setup-repo.sh"
tmp="$(mktemp -d)"
cat > "$tmp/pr.json" <<'J'
{"number":15,"title":"Add item count helper","url":"https://github.com/acme/shop/pull/15",
 "body":"Adds `item_count(order)` for the order summary page.","author":{"login":"dev1"},
 "baseRefName":"main","headRefName":"item-count","reviews":[],"comments":[]}
J
printf 'unit-tests\tpass\t41s\thttps://ci.example/runs/401\nlint\tfail\t12s\thttps://ci.example/runs/402\n' > "$tmp/checks.txt"
bash "$FIXTURES/write-gh-stub.sh" "$tmp/pr.json" "$tmp/checks.txt"
rm -rf "$tmp"
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add gh wrapper"

git checkout -q -b item-count
cat >> shop/orders.py <<'R'


def item_count(order: Order) -> int:
    return sum(item.quantity for item in order.items)
R
cat > tests/test_orders.py <<'R'
import unittest

from shop.orders import LineItem, Order, item_count


class ItemCountTest(unittest.TestCase):
    def test_counts_quantities_across_lines(self):
        order = Order("o1", "ana", [LineItem("pen", 2.0, 3), LineItem("pad", 4.0, 1)])
        self.assertEqual(item_count(order), 4)

    def test_empty_order_has_no_items(self):
        self.assertEqual(item_count(Order("o2", "ana")), 0)


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add item count helper"
