"""One-off: import the legacy brands.yaml into the admin DB.

After this runs, brands.yaml is no longer read by any code (run.py, the admin
server) - it stays in the repo as a historical reference. Safe to re-run:
existing rows (matched by id) are updated in place rather than duplicated.

Usage: python migrate_yaml.py
"""
from __future__ import annotations

from pathlib import Path

import yaml

from server.db import get_brand, init_db, insert_brand, update_brand

CONFIG = Path(__file__).parent / "brands.yaml"


def main() -> None:
    init_db()
    brands = yaml.safe_load(CONFIG.read_text())["brands"]
    added, updated = 0, 0
    for b in brands:
        bid = b["id"]
        type_ = b["type"] if b["type"] in ("shopify", "woocommerce", "generic") else "unknown"
        fields = dict(
            name=b["name"],
            base_url=b["base_url"],
            type_=type_,
            tier=b.get("tier", "emerging"),
            currency=b.get("currency", "PKR"),
            enabled=b.get("enabled", True),
        )
        if get_brand(bid):
            update_brand(
                bid,
                name=fields["name"],
                base_url=fields["base_url"],
                type=fields["type_"],
                tier=fields["tier"],
                currency=fields["currency"],
                enabled=fields["enabled"],
            )
            updated += 1
        else:
            insert_brand(brand_id=bid, **fields)
            added += 1
    print(f"Migrated brands.yaml -> admin DB: {added} added, {updated} updated.")


if __name__ == "__main__":
    main()
