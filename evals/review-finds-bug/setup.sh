#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"

git checkout -q -b bulk-discount
cat > shop/pricing.py <<'R'
from shop.orders import Order

TAX_RATE = 0.08
BULK_QUANTITY = 10
BULK_RATE = 0.05


def line_total(unit_price: float, quantity: int) -> float:
    """Applies a 5% bulk discount when buying 10 or more of an item."""
    price = unit_price * quantity
    if quantity > BULK_QUANTITY:
        price *= 1 - BULK_RATE
    return price


def subtotal(order: Order) -> float:
    return sum(line_total(item.unit_price, item.quantity) for item in order.items)


def total(order: Order) -> float:
    return round(subtotal(order) * (1 + TAX_RATE), 2)
R
git -c user.email=dev@example.com -c user.name=Dev commit -qam "Add bulk discount for 10 or more items"
