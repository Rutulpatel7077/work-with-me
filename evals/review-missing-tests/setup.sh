#!/usr/bin/env bash
set -e
FIXTURES="$(cd "$(dirname "$0")/../_fixtures" && pwd)"
bash "$FIXTURES/shop/setup-repo.sh"
tmp="$(mktemp -d)"

cat > "$tmp/pr.json" <<'J'
{"number":12,"title":"Add shipping to order totals, free for members","url":"https://github.com/acme/shop/pull/12",
 "body":"Order totals now include shipping: 5.00 flat, free from 50.00, always free for members. Negative subtotals are rejected.","author":{"login":"dev1"},
 "baseRefName":"main","headRefName":"member-shipping","reviews":[],"comments":[]}
J
printf 'unit-tests\tpass\t41s\thttps://ci.example/runs/201\nlint\tpass\t12s\thttps://ci.example/runs/202\n' > "$tmp/checks.txt"
bash "$FIXTURES/write-gh-stub.sh" "$tmp/pr.json" "$tmp/checks.txt"
rm -rf "$tmp"
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add gh wrapper"

git checkout -q -b member-shipping
cat > shop/shipping.py <<'R'
FREE_SHIPPING_THRESHOLD = 50.0
FLAT_RATE = 5.0


def shipping_cost(order_subtotal: float, is_member: bool = False) -> float:
    if order_subtotal < 0:
        raise ValueError("subtotal can't be negative")
    if is_member:
        return 0.0
    if order_subtotal >= FREE_SHIPPING_THRESHOLD:
        return 0.0
    return FLAT_RATE
R
cat > shop/pricing.py <<'R'
from shop.orders import Order
from shop.shipping import shipping_cost

TAX_RATE = 0.08


def subtotal(order: Order) -> float:
    return sum(item.unit_price * item.quantity for item in order.items)


def total(order: Order, is_member: bool = False) -> float:
    before_shipping = subtotal(order)
    return round(before_shipping * (1 + TAX_RATE) + shipping_cost(before_shipping, is_member), 2)
R
cat > tests/test_shipping.py <<'R'
import unittest

from shop.shipping import shipping_cost


class ShippingCostTest(unittest.TestCase):
    def test_below_threshold_pays_flat_rate(self):
        self.assertEqual(shipping_cost(49.99), 5.0)

    def test_at_threshold_ships_free(self):
        self.assertEqual(shipping_cost(50.0), 0.0)


if __name__ == "__main__":
    unittest.main()
R
sed -i.bak 's/self.assertEqual(total(order), 10.8)/self.assertEqual(total(order), 15.8)/' tests/test_pricing.py
sed -i.bak 's/32.4/42.4/; s/16.2/21.2/' tests/test_invoice.py
rm -f tests/*.bak
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add shipping to order totals, free for members"
