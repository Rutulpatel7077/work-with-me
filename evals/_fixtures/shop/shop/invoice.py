from shop.orders import Order
from shop.pricing import total


def customer_summary(customer: str, orders: list[Order]) -> dict:
    customer_orders = [order for order in orders if order.customer == customer]
    spent = sum(total(order) for order in customer_orders)
    return {
        "customer": customer,
        "order_count": len(customer_orders),
        "total_spent": round(spent, 2),
        "average_order": round(spent / len(customer_orders), 2),
    }
