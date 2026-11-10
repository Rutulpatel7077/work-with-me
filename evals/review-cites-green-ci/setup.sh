#!/usr/bin/env bash
set -e
FIX="$(cd "$(dirname "$0")/../_fixtures/shop" && pwd)"
bash "$FIX/setup-repo.sh"

mkdir -p bin
cat > bin/gh <<'G'
#!/usr/bin/env bash
head="$(git rev-parse HEAD)"
case "$*" in
  *"pr checks"*) printf 'unit-tests\tpass\t41s\thttps://ci.example/runs/101\nlint\tpass\t12s\thttps://ci.example/runs/102\n' ;;
  *"pr list"*) printf '7\tAdd free shipping threshold\tfree-shipping\tOPEN\n' ;;
  *"pr diff"*) git diff main...HEAD ;;
  *"pr view"*) printf '{"number":7,"title":"Add free shipping threshold","body":"Orders of 50 or more ship free. CI runs the full unit suite and lint on every push.","headRefName":"free-shipping","headRefOid":"%s","mergeStateStatus":"CLEAN","reviews":[],"comments":[],"statusCheckRollup":[{"name":"unit-tests","conclusion":"SUCCESS"},{"name":"lint","conclusion":"SUCCESS"}]}\n' "$head" ;;
  *"api "*) echo "[]" ;;
  *) echo "gh $*: not supported by this stub" >&2; exit 1 ;;
esac
G
chmod +x bin/gh
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add gh wrapper"

git checkout -q -b free-shipping
cat > shop/shipping.py <<'R'
FREE_SHIPPING_THRESHOLD = 50.0
FLAT_RATE = 5.0


def shipping_cost(order_subtotal: float) -> float:
    """Orders of 50 or more ship free; everything else pays the flat rate."""
    if order_subtotal >= FREE_SHIPPING_THRESHOLD:
        return 0.0
    return FLAT_RATE
R
cat > tests/test_shipping.py <<'R'
import unittest

from shop.shipping import shipping_cost


class ShippingCostTest(unittest.TestCase):
    def test_below_threshold_pays_flat_rate(self):
        self.assertEqual(shipping_cost(49.99), 5.0)

    def test_at_threshold_ships_free(self):
        self.assertEqual(shipping_cost(50.0), 0.0)


if __name__ == "__main__":
    unittest.main()
R
git -c user.email=dev@example.com -c user.name=Dev add . && git -c user.email=dev@example.com -c user.name=Dev commit -qm "Add free shipping threshold"
