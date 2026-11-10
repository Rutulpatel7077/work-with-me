from shop.orders import Order

TAX_RATE = 0.08


def subtotal(order: Order) -> float:
    return sum(item.unit_price * item.quantity for item in order.items)


def total(order: Order) -> float:
    return round(subtotal(order) * (1 + TAX_RATE), 2)
