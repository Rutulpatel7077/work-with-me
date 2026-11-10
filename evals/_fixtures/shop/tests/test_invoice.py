import unittest

from shop.invoice import customer_summary
from shop.orders import LineItem, Order


class CustomerSummaryTest(unittest.TestCase):
    def test_summary_for_customer_with_orders(self):
        orders = [
            Order("o1", "ana", [LineItem("pen", 10.0, 1)]),
            Order("o2", "ana", [LineItem("pad", 20.0, 1)]),
            Order("o3", "ben", [LineItem("ink", 5.0, 1)]),
        ]
        summary = customer_summary("ana", orders)
        self.assertEqual(summary["order_count"], 2)
        self.assertEqual(summary["total_spent"], 32.4)
        self.assertEqual(summary["average_order"], 16.2)


if __name__ == "__main__":
    unittest.main()
