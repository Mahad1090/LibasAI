"""Turn scraped products.jsonl into the Flutter app's catalog (lib/data.dart).

Regenerates the `kBrands` and `kProducts` list literals in place; everything
else in data.dart (Product/Brand classes, AppState, option lists) is untouched.

Usage:
    python to_dart.py [--per-brand 14] [--jsonl data/products.jsonl]
"""
from __future__ import annotations

import argparse
import hashlib
import json
import re
from collections import defaultdict
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DATA_DART = ROOT / "lib" / "data.dart"

# taglines for brands the app already knew about + the real ones we scrape
TAGLINES = {
    "sana_safinaz": "Luxury lawn & couture",
    "gul_ahmed": "Heritage textiles, ready to wear",
    "sapphire": "Contemporary eastern essentials",
    "beechtree": "Everyday pret & unstitched",
    "generation": "Pakistan's original ready-to-wear",
    "zellbury": "Colourful, affordable fashion",
    "vanya": "Modern femininity, designer pret",
    "mushq": "Embroidered pret & bridals",
    "zeen": "Wardrobe staples for women",
    "zaaviay": "Independent designer label",
    "suffuse": "Sana Yasir's formal & festive line",
}

PALETTE = [
    "#7A1F2B", "#171515", "#F2E4D2", "#E4C5BA", "#22304A", "#C98F82",
    "#8A9A7E", "#B5583A", "#C9A227", "#9F1733", "#2F4B3F", "#4A3B52",
]

# order matters: more specific words first so "off white" beats "white" etc.
COLOR_WORDS = {
    "off white": "#F3EDE3", "o-white": "#F3EDE3", "offwhite": "#F3EDE3",
    "mint": "#B8D8C7", "olive": "#6B6B3D", "khaki": "#B7A98B",
    "charcoal": "#33302E", "beige": "#D8C7A8", "tan": "#C9A97E",
    "black": "#171515", "white": "#FBF7F0", "ivory": "#F7EDDF", "cream": "#F2E4D2",
    "red": "#9F1733", "maroon": "#7A1F2B", "wine": "#5C1A2B", "fuchsia": "#B02A6B",
    "pink": "#E4A9BE", "blush": "#E4C5BA", "rose": "#C98F82",
    "peach": "#F0C9A8", "coral": "#E08A6E",
    "navy": "#22304A", "blue": "#3A5A80", "denim": "#4A6079", "sky": "#8FB3D4",
    "green": "#5B7355", "sage": "#8A9A7E", "emerald": "#2F6E4E", "teal": "#2F6E6A",
    "brown": "#6B4A32", "chocolate": "#4B3221", "rust": "#B5583A",
    "gold": "#C9A227", "mustard": "#C99A2E", "yellow": "#D9B44A",
    "purple": "#4A3B52", "lilac": "#B4A0C8", "lavender": "#B9A7CE", "mauve": "#9C7C8A",
    "grey": "#8C8783", "gray": "#8C8783", "silver": "#C4C0BA",
    "orange": "#C4713A", "brick": "#A44A34",
}


def _color_to_hex(name: str) -> str | None:
    n = name.strip().lower()
    for word, hex_ in COLOR_WORDS.items():
        # word-boundary match so "red" doesn't fire inside "embroidered"
        if re.search(r"(?<![a-z])" + re.escape(word) + r"(?![a-z])", n):
            return hex_
    return None


def _options(rec: dict) -> tuple[list[dict], dict[str, int]]:
    opts = rec.get("attributes", {}).get("options") or []
    idx: dict[str, int] = {}
    for o in opts:
        n = (o.get("name") or "").lower()
        if "colour" in n or "color" in n:
            idx["color"] = o.get("position", 1)
        elif "size" in n:
            idx["size"] = o.get("position", 1)
    return opts, idx


def _values_at(opts: list[dict], position: int) -> list[str]:
    for o in opts:
        if o.get("position") == position:
            return [str(v) for v in (o.get("values") or [])]
    return []

OCCASIONS = [
    ("wedding", "Wedding"), ("bridal", "Wedding"), ("mehndi", "Wedding"),
    ("eid", "Eid"), ("festive", "Festive"), ("party", "Party"),
    ("formal", "Formal"), ("wear-to-work", "Office"), ("office", "Office"),
    ("casual", "Casual"), ("summer", "Casual"), ("everyday", "Everyday"),
]

CATEGORY_MAP = {
    "pret": "Pret", "unstitched": "Unstitched", "stitched": "Pret",
    "kurta": "Kurta", "kurti": "Kurti", "shirt": "Kurta",
    "shalwar": "Shalwar Kameez", "trouser": "Bottoms", "pants": "Bottoms",
    "dupatta": "Dupatta", "shawl": "Shawl", "waistcoat": "Waistcoat",
    "bag": "Accessories", "footwear": "Accessories", "jewellery": "Accessories",
    "fragrance": "Accessories", "co-ord": "Co-ord", "coord": "Co-ord",
}

SIZE_ORDER = ["XXS", "XS", "S", "M", "L", "XL", "XXL", "3XL"]


def q(s: str) -> str:
    return "'" + s.replace("\\", "\\\\").replace("'", "\\'").replace("\n", " ").strip() + "'"


def pick_category(rec: dict) -> str:
    hay = f"{rec.get('product_type','')} {rec['title']} {' '.join(rec.get('tags',[]))}".lower()
    for key, val in CATEGORY_MAP.items():
        if key in hay:
            return val
    return "Pret"


def pick_occasion(rec: dict) -> str:
    hay = f"{rec['title']} {' '.join(rec.get('tags',[]))}".lower()
    for key, val in OCCASIONS:
        if key in hay:
            return val
    return "Everyday"


def pick_colors(rec: dict) -> list[str]:
    """Colour swatches, best source first:
      1. Shopify 'Color' variant option values
      2. a colour word in the title
      3. dominant colours sampled from the product photo
      4. [] - the app then hides the colour section rather than guess
    """
    opts, idx = _options(rec)
    if "color" in idx:
        hexes: list[str] = []
        for nm in _values_at(opts, idx["color"]):
            h = _color_to_hex(nm)
            if h and h not in hexes:
                hexes.append(h)
        if hexes:
            return hexes[:4]

    title_hex = _color_to_hex(rec["title"])
    if title_hex:
        return [title_hex]

    if rec.get("images"):
        try:
            from colors import dominant_colors_cached

            found = dominant_colors_cached(img(rec["images"][0]))
            if found:
                return found
        except Exception:
            pass
    return []


def _norm_size(s: str) -> str:
    s = s.strip()
    return s.upper() if s.upper() in SIZE_ORDER else s


def _order_sizes(sizes) -> list[str]:
    sizes = list(sizes)
    if all(s in SIZE_ORDER for s in sizes):
        return sorted(sizes, key=SIZE_ORDER.index)
    return sizes


def pick_sizes(rec: dict) -> tuple[list[str], list[str]]:
    """(all sizes, in-stock sizes) from the Shopify 'Size' option + variants."""
    opts, idx = _options(rec)
    variants = rec.get("variants", []) or []

    if "size" in idx:
        pos = idx["size"]
        sizes = [_norm_size(s) for s in _values_at(opts, pos)]
        in_stock: list[str] = []
        for v in variants:
            toks = [t.strip() for t in (v.get("title") or "").split(" / ")]
            if len(toks) >= pos:
                s = _norm_size(toks[pos - 1])
                if v.get("available") and s not in in_stock:
                    in_stock.append(s)
        if sizes:
            sizes = _order_sizes(dict.fromkeys(sizes))
            return sizes[:8], [s for s in sizes if s in in_stock]

    # no size option: single-variant products, unstitched fabric, accessories
    if "color" in idx or any(
        w in rec["title"].lower() for w in ("bag", "clutch", "shawl", "dupatta", "scarf", "jewel")
    ):
        return ["One Size"], (["One Size"] if any(v.get("available") for v in variants) else [])
    if any(w in rec["title"].lower() for w in ("unstitched", "fabric", "3 piece", "3pc", "2 piece")):
        return ["Unstitched"], (["Unstitched"] if any(v.get("available") for v in variants) else [])
    return ["S", "M", "L"], ["S", "M", "L"]


def rupees(v) -> str:
    try:
        return f"Rs. {int(round(float(v))):,}"
    except (TypeError, ValueError):
        return "Rs. 0"


def img(url: str) -> str:
    if url.startswith("//"):
        return "https:" + url
    return url


_CODE_TITLE = re.compile(r"^[A-Za-z]{1,5}[-\s]?\d{2,}[A-Za-z0-9\-\s]*$")


def usable(rec: dict) -> bool:
    title = (rec.get("title") or "").strip()
    if not title or _CODE_TITLE.match(title):  # skip bare SKU-code titles
        return False
    if len(title) < 6:
        return False
    return bool(rec.get("images")) and rec.get("price_min") and float(rec["price_min"]) > 0


def main() -> None:
    ap = argparse.ArgumentParser()
    ap.add_argument("--jsonl", default="data/products.jsonl")
    ap.add_argument("--per-brand", type=int, default=14)
    args = ap.parse_args()

    path = Path(__file__).parent / args.jsonl
    by_brand: dict[str, list[dict]] = defaultdict(list)
    totals: dict[str, int] = defaultdict(int)
    meta: dict[str, dict] = {}
    order: list[str] = []
    # single streaming pass - the JSONL can be ~100MB
    with path.open(encoding="utf-8") as fh:
        for line in fh:
            if not line.strip():
                continue
            rec = json.loads(line)
            bid = rec["brand_id"]
            if bid not in totals:
                order.append(bid)
            totals[bid] += 1
            meta.setdefault(bid, rec)
            if usable(rec):
                by_brand[bid].append(rec)

    brand_lines, product_lines = [], []
    pid = 0
    for bid in order:
        recs = by_brand.get(bid, [])
        if not recs:
            continue
        m = meta[bid]
        emerging = m.get("brand_tier") == "emerging"
        brand_lines.append(
            f"  Brand({q(bid)}, {q(m['brand_name'])}, "
            f"{q(TAGLINES.get(bid, 'Pakistani fashion'))}, {str(emerging).lower()}, {totals[bid]}),"
        )
        # prefer products that still have stock, then spread across the catalog
        in_stock = [r for r in recs if any(v.get("available") for v in r.get("variants", []))]
        pool = in_stock if len(in_stock) >= args.per_brand else recs
        step = max(1, len(pool) // args.per_brand)
        sample = pool[::step][: args.per_brand]
        for rec in sample:
            pid += 1
            colors = ", ".join(f"_c({q(c)})" for c in pick_colors(rec))
            all_sizes, stock_sizes = pick_sizes(rec)
            sizes = ", ".join(q(s) for s in all_sizes)
            in_stock = ", ".join(q(s) for s in stock_sizes)
            old = rec.get("price_max")
            old_str = rupees(old) if old and float(old) > float(rec["price_min"]) * 1.05 else ""
            product_lines.append(
                "  Product("
                f"id: 'p{pid}', title: {q(rec['title'][:60])}, brand: {q(rec['brand_name'])}, "
                f"brandId: {q(bid)}, emerging: {str(emerging).lower()}, "
                f"price: {q(rupees(rec['price_min']))}, oldPrice: {q(old_str)}, "
                f"category: {q(pick_category(rec))}, occasion: {q(pick_occasion(rec))}, "
                f"sizes: const [{sizes}], inStockSizes: const [{in_stock}], "
                f"colors: [{colors}], "
                f"imgLabel: {q('PRODUCT PHOTO - ' + rec['title'][:40])}, "
                f"imageUrl: {q(img(rec['images'][0]))}, productUrl: {q(rec.get('url',''))}),"
            )

    src = DATA_DART.read_text(encoding="utf-8")

    # keep logos already scraped into data.dart (scrape_logos.py) across regens
    existing_logos = dict(
        re.findall(r"Brand\('([a-z_]+)'[^\n]*logoUrl: '([^']*)'", src)
    )
    brand_lines = [
        (ln[:-2] + f", logoUrl: '{existing_logos[bid]}'),")
        if (bid := re.search(r"Brand\('([a-z_]+)'", ln).group(1)) in existing_logos
        else ln
        for ln in brand_lines
    ]

    src = re.sub(
        r"const kBrands = <Brand>\[.*?\n\];",
        "const kBrands = <Brand>[\n" + "\n".join(brand_lines) + "\n];",
        src, count=1, flags=re.S,
    )
    src = re.sub(
        r"final kProducts = <Product>\[.*?\n\];",
        "final kProducts = <Product>[\n" + "\n".join(product_lines) + "\n];",
        src, count=1, flags=re.S,
    )
    DATA_DART.write_text(src, encoding="utf-8")
    print(f"{len(brand_lines)} brands, {pid} products -> {DATA_DART}")


if __name__ == "__main__":
    main()
