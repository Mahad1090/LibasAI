"""Product Aggregation Module - CLI entry point.

Usage:
    python run.py                     # all enabled brands
    python run.py --brand beechtree   # one brand
    python run.py --out data/products.jsonl

Brands come from the admin DB (scraper/data/admin.db), managed via the admin
app / API (scraper/server/app.py) - see migrate_yaml.py for importing the
legacy brands.yaml once. Writes one JSON object per line (JSONL) - easy to
load into Postgres later, or into pandas for the recommendation spike.
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

from normalize import normalize_generic, normalize_shopify, normalize_woocommerce
from server.db import init_db, list_brands
from generic_source import fetch_products as fetch_generic
from shopify_source import fetch_products as fetch_shopify
from woocommerce_source import fetch_products as fetch_woocommerce

ADAPTERS = {
    "shopify": (fetch_shopify, normalize_shopify),
    "woocommerce": (fetch_woocommerce, normalize_woocommerce),
    "generic": (fetch_generic, normalize_generic),
}


def load_brands(only: str | None) -> list[dict]:
    init_db()
    brands = list_brands(enabled_only=True)
    if only:
        brands = [b for b in brands if b["id"] == only]
    return brands


def scrape_brand(brand: dict, *, log=print) -> list[dict]:
    adapter = ADAPTERS.get(brand["type"])
    if adapter is None:
        log(f"  ! {brand['id']}: type '{brand['type']}' has no adapter yet, skipping")
        return []
    fetch, normalize = adapter
    records = []
    for raw in fetch(brand["base_url"]):
        try:
            records.append(normalize(raw, brand))
        except Exception as e:  # noqa: BLE001 - keep going on a single bad product
            log(f"  ! {brand['id']}: skipped a product ({e})")
    return records


def main() -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument("--brand", help="only scrape this brand id")
    ap.add_argument("--out", default="data/products.jsonl", help="output JSONL path")
    args = ap.parse_args()

    brands = load_brands(args.brand)
    if not brands:
        print("No matching enabled brands. (Have you run migrate_yaml.py / added brands via the admin app?)")
        return 1

    out_path = Path(__file__).parent / args.out
    out_path.parent.mkdir(parents=True, exist_ok=True)

    total = 0
    with out_path.open("w", encoding="utf-8") as fh:
        for brand in brands:
            print(f"- {brand['name']} ({brand['base_url']}) [{brand['type']}]")
            try:
                recs = scrape_brand(brand)
            except Exception as e:  # noqa: BLE001 - one brand failing must not kill the run
                print(f"  ! {brand['id']}: FAILED ({e}); continuing")
                continue
            for r in recs:
                fh.write(json.dumps(r, ensure_ascii=False) + "\n")
            total += len(recs)
            print(f"  {len(recs)} products")

    print(f"\nWrote {total} products -> {out_path}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
