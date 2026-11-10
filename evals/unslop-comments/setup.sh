#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"

cat > shop/report.py <<'R'
# ===== IMPORTS =====
# Import the Decimal class
from decimal import Decimal, ROUND_HALF_UP

# Import the total function
from shop.pricing import total


# ===== HELPERS =====
def revenue_report(orders):
    """This function generates a revenue report for the orders."""
    # Initialize the total revenue variable
    revenue = Decimal("0")
    # Loop through all the orders
    for order in orders:
        # Add the order total to the revenue
        revenue += Decimal(str(total(order)))
        # print(order)
    # The accounting ledger requires half-up rounding, not Python's default banker's rounding.
    revenue = revenue.quantize(Decimal("0.01"), rounding=ROUND_HALF_UP)
    # Return the result
    # old_revenue = sum(total(o) for o in orders)
    return {"orders": len(orders), "revenue": float(revenue)}  # Updated to return a dict
R
cat > tests/test_report.py <<'R'
import unittest

from shop.orders import LineItem, Order
from shop.report import revenue_report


class ReportTest(unittest.TestCase):
    def test_revenue_report(self):
        orders = [Order("o1", "ana", [LineItem("pen", 10.0, 1)])]
        self.assertEqual(revenue_report(orders), {"orders": 1, "revenue": 10.8})


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add revenue report"
