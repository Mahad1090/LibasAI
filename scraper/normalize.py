"""Normalize heterogeneous brand product data into LibasAI's unified schema.

The unified record maps onto the planned Postgres design: a few typed columns
for things every product has (id, brand, title, price, url, images) plus a
JSONB `attributes` blob for the variable per-brand fields (fabric, occasion,
pieces, work type, ...). See CLAUDE.md - JSONB is a deliberate choice.
"""
from __future__ import annotations

import re
from datetime import datetime, timezone
from typing import Any

_TAG_RE = re.compile(r"<[^>]+>")


def _strip_html(text: str | None) -> str:
    if not text:
        return ""
    return _TAG_RE.sub("", text).replace("&nbsp;", " ").strip()


def _price_range(variants: list[dict]) -> tuple[float | None, float | None]:
    prices = [float(v["price"]) for v in variants if v.get("price") not in (None, "")]
    return (min(prices), max(prices)) if prices else (None, None)


def normalize_shopify(product: dict, brand: dict) -> dict[str, Any]:
    variants = product.get("variants", []) or []
    images = [img["src"] for img in product.get("images", []) if img.get("src")]
    lo, hi = _price_range(variants)
    handle = product.get("handle", "")
    in_stock = any(v.get("available") for v in variants)

    return {
        "product_uid": f"{brand['id']}:{product['id']}",
        "brand_id": brand["id"],
        "brand_name": brand["name"],
        "brand_tier": brand.get("tier", "unknown"),
        "title": product.get("title", "").strip(),
        "description": _strip_html(product.get("body_html")),
        "product_type": product.get("product_type", ""),
        "vendor": product.get("vendor", ""),
        "tags": product.get("tags", []),
        "price_min": lo,
        "price_max": hi,
        "currency": brand.get("currency", "PKR"),
        "in_stock": in_stock,
        "url": f"{brand['base_url'].rstrip('/')}/products/{handle}",
        "images": images,
        "variants": [
            {
                "sku": v.get("sku"),
                "title": v.get("title"),
                "price": v.get("price"),
                "available": v.get("available"),
            }
            for v in variants
        ],
        "attributes": {
            "options": product.get("options", []),
            "published_at": product.get("published_at"),
            "shopify_updated_at": product.get("updated_at"),
        },
        "source": "shopify_products_json",
        "scraped_at": datetime.now(timezone.utc).isoformat(),
    }


def _wc_money(minor_value: Any, minor_unit: int) -> float | None:
    """WooCommerce Store API prices are strings in minor units (e.g. cents)."""
    if minor_value in (None, ""):
        return None
    try:
        return float(minor_value) / (10 ** minor_unit)
    except (TypeError, ValueError):
        return None


def normalize_woocommerce(product: dict, brand: dict) -> dict[str, Any]:
    prices = product.get("prices") or {}
    minor_unit = int(prices.get("currency_minor_unit", 2) or 2)
    price = _wc_money(prices.get("price"), minor_unit)
    regular = _wc_money(prices.get("regular_price"), minor_unit) or price
    lo = price if price is not None else regular
    hi = regular if regular is not None else price

    images = [img["src"] for img in (product.get("images") or []) if img.get("src")]
    variations = product.get("variations") or []
    # Store API variation objects expose `attributes` (name/value pairs) but
    # not always their own price/availability at list-fetch time.
    options = [
        {"name": a.get("name"), "values": [a.get("value")], "position": i + 1}
        for i, a in enumerate(
            {a.get("name"): a for v in variations for a in (v.get("attributes") or [])}.values()
        )
    ]

    return {
        "product_uid": f"{brand['id']}:{product.get('id')}",
        "brand_id": brand["id"],
        "brand_name": brand["name"],
        "brand_tier": brand.get("tier", "unknown"),
        "title": (product.get("name") or "").strip(),
        "description": _strip_html(product.get("description") or product.get("short_description")),
        "product_type": ", ".join(c.get("name", "") for c in (product.get("categories") or [])),
        "vendor": brand["name"],
        "tags": [t.get("name", "") for t in (product.get("tags") or [])],
        "price_min": lo,
        "price_max": hi,
        "currency": prices.get("currency_code") or brand.get("currency", "PKR"),
        "in_stock": bool(product.get("is_in_stock", True)),
        "url": product.get("permalink") or f"{brand['base_url'].rstrip('/')}/?p={product.get('id')}",
        "images": images,
        "variants": [
            {
                "sku": v.get("sku"),
                "title": " / ".join(a.get("value", "") for a in (v.get("attributes") or [])),
                "price": price,
                "available": True,
            }
            for v in variations
        ],
        "attributes": {"options": options, "published_at": None, "shopify_updated_at": None},
        "source": "woocommerce_store_api",
        "scraped_at": datetime.now(timezone.utc).isoformat(),
    }


def normalize_generic(node: dict, brand: dict) -> dict[str, Any]:
    """Normalize a schema.org Product JSON-LD node (see generic_source.py)."""
    import hashlib

    page_url = node.get("_page_url") or node.get("url") or ""
    offers = node.get("offers")
    if isinstance(offers, list):
        offers = offers[0] if offers else {}
    offers = offers or {}

    def _num(v: Any) -> float | None:
        try:
            return float(v)
        except (TypeError, ValueError):
            return None

    price = _num(offers.get("price") or offers.get("lowPrice"))
    high = _num(offers.get("highPrice")) or price

    images_raw = node.get("image")
    if isinstance(images_raw, str):
        images = [images_raw]
    elif isinstance(images_raw, list):
        images = [i if isinstance(i, str) else i.get("url") for i in images_raw if i]
    else:
        images = []

    availability = str(offers.get("availability") or "").lower()
    in_stock = "outofstock" not in availability if availability else True

    sku = node.get("sku") or node.get("productID") or ""
    uid = sku or hashlib.sha1(page_url.encode("utf-8")).hexdigest()[:16]

    return {
        "product_uid": f"{brand['id']}:{uid}",
        "brand_id": brand["id"],
        "brand_name": brand["name"],
        "brand_tier": brand.get("tier", "unknown"),
        "title": (node.get("name") or "").strip(),
        "description": _strip_html(node.get("description")),
        "product_type": "",
        "vendor": brand["name"],
        "tags": [],
        "price_min": price,
        "price_max": high,
        "currency": offers.get("priceCurrency") or brand.get("currency", "PKR"),
        "in_stock": in_stock,
        "url": page_url or brand["base_url"],
        "images": [i for i in images if i],
        "variants": [],
        "attributes": {"options": [], "published_at": None, "shopify_updated_at": None},
        "source": "generic_jsonld",
        "scraped_at": datetime.now(timezone.utc).isoformat(),
    }
