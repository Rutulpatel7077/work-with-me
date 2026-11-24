#!/usr/bin/env bash
set -e
FIXTURES="$(cd "$(dirname "$0")/../_fixtures" && pwd)"
bash "$FIXTURES/shop/setup-repo.sh"
tmp="$(mktemp -d)"
cat > "$tmp/pr.json" <<'J'
{"number":9,"title":"[SHOP-42] Add bulk discount","url":"https://github.com/acme/shop/pull/9",
 "body":"Buying 10 or more of an item gets 5% off.\n\nTicket: https://tracker.example/browse/SHOP-42","author":{"login":"dev1"},
 "baseRefName":"main","headRefName":"bulk-discount","reviews":[],
 "comments":[{"author":{"login":"deploy-bot"},"body":"Preview deployed: https://shop-pr9.preview.example"}]}
J
printf 'unit-tests\tpass\t41s\thttps://ci.example/runs/301\nlint\tpass\t12s\thttps://ci.example/runs/302\n' > "$tmp/checks.txt"
bash "$FIXTURES/write-gh-stub.sh" "$tmp/pr.json" "$tmp/checks.txt"
rm -rf "$tmp"
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add gh wrapper"

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
