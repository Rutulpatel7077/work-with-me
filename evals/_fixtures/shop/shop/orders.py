from dataclasses import dataclass, field


@dataclass
class LineItem:
    name: str
    unit_price: float
    quantity: int


@dataclass
class Order:
    order_id: str
    customer: str
    items: list[LineItem] = field(default_factory=list)
