import unittest

from shop.orders import LineItem, Order
from shop.pricing import subtotal, total


class PricingTest(unittest.TestCase):
    def test_subtotal_adds_every_line(self):
        order = Order("o1", "ana", [LineItem("pen", 2.0, 3), LineItem("pad", 4.0, 1)])
        self.assertEqual(subtotal(order), 10.0)

    def test_total_includes_tax(self):
        order = Order("o1", "ana", [LineItem("pen", 10.0, 1)])
        self.assertEqual(total(order), 10.8)


if __name__ == "__main__":
    unittest.main()
