#!/usr/bin/env bash
set -e
FIXTURES="$(cd "$(dirname "$0")/../_fixtures" && pwd)"
bash "$FIXTURES/shop/setup-repo.sh"
tmp="$(mktemp -d)"

cat > "$tmp/pr.json" <<'J'
{"number":14,"title":"Add loyalty points","url":"https://github.com/acme/shop/pull/14",
 "body":"Customers earn 1 point per dollar of the order subtotal. Awarding is idempotent, so the checkout retry is safe. Adds a refunded order status; refunding takes the points back.","author":{"login":"dev1"},
 "baseRefName":"main","headRefName":"loyalty-points","reviews":[],"comments":[]}
J
printf 'unit-tests\tpass\t39s\thttps://ci.example/runs/301\nlint\tpass\t11s\thttps://ci.example/runs/302\n' > "$tmp/checks.txt"
bash "$FIXTURES/write-gh-stub.sh" "$tmp/pr.json" "$tmp/checks.txt"
rm -rf "$tmp"
cat > shop/statuses.py <<'R'
STATUSES = ("pending", "paid", "shipped")
R
cat > shop/reports.py <<'R'
from shop.orders import Order
from shop.pricing import total

COUNTS_AS_REVENUE = {"pending": False, "paid": True, "shipped": True}


def revenue(orders: list[Order], status_by_order: dict[str, str]) -> float:
    counted = [order for order in orders if COUNTS_AS_REVENUE[status_by_order[order.order_id]]]
    return round(sum(total(order) for order in counted), 2)
R
cat > tests/test_reports.py <<'R'
import unittest

from shop.orders import LineItem, Order
from shop.reports import revenue


class RevenueTest(unittest.TestCase):
    def test_pending_orders_are_not_revenue(self):
        orders = [Order("o1", "ana", [LineItem("pen", 10.0, 1)]), Order("o2", "ben", [LineItem("pad", 20.0, 1)])]
        self.assertEqual(revenue(orders, {"o1": "paid", "o2": "pending"}), 10.8)


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add gh wrapper, order statuses and revenue report"

git checkout -q -b loyalty-points
cat > shop/loyalty.py <<'R'
from shop.orders import Order

POINTS_PER_DOLLAR = 1


def order_points(order: Order) -> int:
    spent = sum(item.unit_price for item in order.items)
    return int(spent * POINTS_PER_DOLLAR)


class PointsLedger:
    def __init__(self) -> None:
        self.balances: dict[str, int] = {}

    def award(self, order: Order) -> int:
        """Award points for an order. Idempotent: awarding the same order twice never double-counts."""
        self.balances[order.customer] = self.balances.get(order.customer, 0) + order_points(order)
        return self.balances[order.customer]

    def refund(self, order: Order) -> int:
        self.balances[order.customer] = self.balances.get(order.customer, 0) - order_points(order)
        return self.balances[order.customer]
R
cat > shop/statuses.py <<'R'
STATUSES = ("pending", "paid", "shipped", "refunded")
R
cat > tests/test_loyalty.py <<'R'
import unittest

from shop.loyalty import PointsLedger, order_points
from shop.orders import LineItem, Order


class LoyaltyTest(unittest.TestCase):
    def test_one_point_per_dollar(self):
        order = Order("o1", "ana", [LineItem("pen", 10.0, 1), LineItem("pad", 20.0, 1)])
        self.assertEqual(order_points(order), 30)

    def test_award_adds_to_the_customer_balance(self):
        ledger = PointsLedger()
        self.assertEqual(ledger.award(Order("o1", "ana", [LineItem("pen", 10.0, 1)])), 10)
        self.assertEqual(ledger.award(Order("o2", "ana", [LineItem("pad", 20.0, 1)])), 30)

    def test_refund_takes_the_points_back(self):
        ledger = PointsLedger()
        order = Order("o1", "ana", [LineItem("pen", 10.0, 1)])
        ledger.award(order)
        self.assertEqual(ledger.refund(order), 0)


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add loyalty points"
