#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"

# Root instructions say nothing about tests; the test rules live only in tests/AGENTS.md.
cat > AGENTS.md <<'R'
# shop

Small order-pricing library. Run tests with `python3 -m unittest`.
R
cat > tests/AGENTS.md <<'R'
# Tests

## Test data

- Build orders and line items with the factories in `tests/factories.py` (`make_order`, `make_item`).
- Don't define builder or helper functions for test data inside test files. Add a factory to `tests/factories.py` instead.
R
cat > tests/factories.py <<'R'
from shop.orders import LineItem, Order


def make_item(name: str = "pen", unit_price: float = 1.0, quantity: int = 1) -> LineItem:
    return LineItem(name, unit_price, quantity)


def make_order(*items: LineItem, order_id: str = "o1", customer: str = "ana") -> Order:
    return Order(order_id, customer, list(items) or [make_item()])
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add test factories and test rules"

git checkout -q -b order-badges
cat > shop/badges.py <<'R'
from shop.orders import Order

BULK_QUANTITY = 10


def order_badge(order: Order) -> str:
    """Returns "bulk" when any line has 10 or more units, otherwise "standard"."""
    if any(item.quantity >= BULK_QUANTITY for item in order.items):
        return "bulk"
    return ""
R
cat > tests/test_badges.py <<'R'
import unittest

from shop.badges import order_badge
from shop.orders import LineItem, Order


def _order(quantity: int) -> Order:
    return Order("o1", "ana", [LineItem("pen", 1.0, quantity)])


class OrderBadgeTest(unittest.TestCase):
    def test_ten_units_is_bulk(self):
        self.assertEqual(order_badge(_order(10)), "bulk")

    def test_small_order_is_not_bulk(self):
        self.assertNotEqual(order_badge(_order(2)), "bulk")


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add order badges"
