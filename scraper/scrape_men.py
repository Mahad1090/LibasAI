"""Scrape Pakistani Men's Fashion Brands.

Usage:
    python scrape_men.py
    python scrape_men.py --brand junaid_jamshed
    python scrape_men.py --limit 50
"""
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path

# Add current dir to sys.path
sys.path.insert(0, str(Path(__file__).parent))

from shopify_source import fetch_products
from normalize import normalize_shopify

MEN_BRANDS = [
    {
        "id": "junaid_jamshed",
        "name": "J. Junaid Jamshed",
        "type": "shopify",
        "base_url": "https://www.junaidjamshed.com",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "diners",
        "name": "Diners",
        "type": "shopify",
        "base_url": "https://diners.com.pk",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "edenrobe",
        "name": "Edenrobe",
        "type": "shopify",
        "base_url": "https://edenrobe.com",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "charcoal",
        "name": "Charcoal",
        "type": "shopify",
        "base_url": "https://charcoal.com.pk",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "amir_adnan",
        "name": "Amir Adnan",
        "type": "shopify",
        "base_url": "https://amiradnan.com",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "ismail_farid",
        "name": "Ismail Farid",
        "type": "shopify",
        "base_url": "https://ismailfarid.com",
        "tier": "emerging",
        "currency": "PKR",
    },
    {
        "id": "the_cambridge_shop",
        "name": "Cambridge",
        "type": "shopify",
        "base_url": "https://thecambridgeshop.com",
        "tier": "established",
        "currency": "PKR",
    },
    {
        "id": "mohtaram",
        "name": "Mohtaram",
        "type": "shopify",
        "base_url": "https://mohtaram.com",
        "tier": "emerging",
        "currency": "PKR",
    },
]


def is_mens_product(raw: dict) -> bool:
    title = (raw.get("title") or "").lower()
    ptype = (raw.get("product_type") or "").lower()
    vendor = (raw.get("vendor") or "").lower()
    tags = [str(t).lower() for t in (raw.get("tags") or [])]
    tag_str = " ".join(tags)
    combined = f"{title} {ptype} {vendor} {tag_str}"

    # Strict exclusions
    if any(w in vendor for w in ["women", "woman", "ladies", "girls"]):
        return False
    if any(w in ptype for w in ["women", "woman", "ladies", "girls"]):
        return False
    if "women-unstitched" in tag_str or "womens-new-in" in tag_str:
        return False

    men_keywords = [
        "men", "man", "mens", "kameez shalwar", "shalwar kameez", "kurta", "waistcoat", 
        "sherwani", "prince coat", "latha", "boski", "blazer", "trouser", "men's", "gents",
        "male", "boy"
    ]
    women_keywords = ["women", "woman", "ladies", "girl", "lehenga", "saree", "dupatta", "abaya", "kurti"]

    has_men = any(k in combined for k in men_keywords)
    has_women = any(k in combined for k in women_keywords)

    if has_women and not has_men:
        return False
    return has_men


def main() -> int:
    parser = argparse.ArgumentParser(description="Scrape Pakistani menswear brands")
    parser.add_argument("--brand", help="Only scrape this brand id")
    parser.add_argument("--pages", type=int, default=2, help="Max pages per brand (250 items/page)")
    parser.add_argument("--out", default="data/men_products.jsonl", help="Output path")
    args = parser.parse_args()

    brands = MEN_BRANDS
    if args.brand:
        brands = [b for b in brands if b["id"] == args.brand]

    out_file = Path(__file__).parent / args.out
    out_file.parent.mkdir(parents=True, exist_ok=True)

    total = 0
    with out_file.open("w", encoding="utf-8") as f:
        for b in brands:
            print(f"Scraping {b['name']} ({b['base_url']})...")
            count = 0
            try:
                for raw in fetch_products(b["base_url"], max_pages=args.pages, delay=0.4):
                    if is_mens_product(raw):
                        rec = normalize_shopify(raw, b)
                        rec["department"] = "men"
                        f.write(json.dumps(rec, ensure_ascii=False) + "\n")
                        count += 1
            except Exception as e:
                print(f"  Error scraping {b['name']}: {e}")
            print(f"  -> Saved {count} men's products for {b['name']}")
            total += count

    print(f"\nDone! Scraped {total} total men's products to {out_file}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
