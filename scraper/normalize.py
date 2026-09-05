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


def _wc_variant_available(v: dict) -> bool:
    # Field name varies by WooCommerce/Blocks version - check every spelling
    # we've seen rather than trust one, and default to "available" so a
    # missing field doesn't silently hide an in-stock variant.
    if "is_in_stock" in v:
        return bool(v["is_in_stock"])
    status = v.get("stock_status") or (v.get("stock_availability") or {}).get("class")
    if status:
        return str(status).lower() in ("instock", "in-stock", "in_stock")
    return True


def _wc_options(variant_list: list[dict]) -> list[dict]:
    """Aggregate every variant's attribute name/value pairs into option
    definitions, preserving first-seen order and every distinct value seen -
    not just the last one (dict comprehensions keyed by name alone would
    silently drop earlier values, e.g. "Size: M" if a later variant is "L")."""
    order: list[str] = []
    values_by_name: dict[str, list[str]] = {}
    for v in variant_list:
        for a in v.get("attributes") or []:
            name, value = a.get("name"), a.get("value")
            if not name:
                continue
            if name not in order:
                order.append(name)
                values_by_name[name] = []
            if value and value not in values_by_name[name]:
                values_by_name[name].append(value)
    return [{"name": n, "values": values_by_name[n], "position": i + 1} for i, n in enumerate(order)]


def normalize_woocommerce(product: dict, brand: dict) -> dict[str, Any]:
    prices = product.get("prices") or {}
    minor_unit = int(prices.get("currency_minor_unit", 2) or 2)
    price = _wc_money(prices.get("price"), minor_unit)
    regular = _wc_money(prices.get("regular_price"), minor_unit) or price

    images = [img["src"] for img in (product.get("images") or []) if img.get("src")]
    variations = product.get("variations") or []
    # The list endpoint's `variations` only enumerates possible attribute
    # combinations; `_variations_detail` (fetched per-product from
    # /products/{id}/variations by woocommerce_source.py) has the real
    # per-variant sku/price/stock when available.
    detail = product.get("_variations_detail") or []

    if detail:
        variant_records = []
        for v in detail:
            v_prices = v.get("prices") or prices
            v_price = _wc_money(v_prices.get("price"), int(v_prices.get("currency_minor_unit", minor_unit) or minor_unit))
            variant_records.append({
                "sku": v.get("sku"),
                "title": " / ".join(a.get("value", "") for a in (v.get("attributes") or [])),
                "price": v_price if v_price is not None else price,
                "available": _wc_variant_available(v),
            })
        options = _wc_options(detail)
        variant_prices = [r["price"] for r in variant_records if r["price"] is not None]
        lo = min(variant_prices) if variant_prices else price
        hi = max(variant_prices) if variant_prices else (regular or price)
        in_stock = any(r["available"] for r in variant_records) if variant_records else bool(product.get("is_in_stock", True))
    else:
        # No detail could be fetched (or a simple product) - fall back to the
        # product-level price/stock shared across whatever attributes the
        # list endpoint exposed.
        lo = price if price is not None else regular
        hi = regular if regular is not None else price
        options = _wc_options(variations)
        variant_records = [
            {
                "sku": v.get("sku"),
                "title": " / ".join(a.get("value", "") for a in (v.get("attributes") or [])),
                "price": price,
                "available": True,
            }
            for v in variations
        ]
        in_stock = bool(product.get("is_in_stock", True))

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
        "in_stock": in_stock,
        "url": product.get("permalink") or f"{brand['base_url'].rstrip('/')}/?p={product.get('id')}",
        "images": images,
        "variants": variant_records,
        "attributes": {"options": options, "published_at": None, "shopify_updated_at": None},
        "source": "woocommerce_store_api",
        "scraped_at": datetime.now(timezone.utc).isoformat(),
    }


def normalize_generic(node: dict, brand: dict) -> dict[str, Any]:
    """Normalize a schema.org Product JSON-LD node (see generic_source.py)."""
    import hashlib

    def _num(v: Any) -> float | None:
        try:
            return float(v)
        except (TypeError, ValueError):
            return None

    def _first_offer(n: dict) -> dict:
        o = n.get("offers")
        if isinstance(o, list):
            o = o[0] if o else {}
        return o or {}

    def _offer_in_stock(o: dict, default: bool = True) -> bool:
        avail = str(o.get("availability") or "").lower()
        return "outofstock" not in avail if avail else default

    def _attrs(n: dict) -> list[tuple[str, str]]:
        """Real size/color-ish attributes from a schema.org node: its
        `additionalProperty` (PropertyValue name/value pairs) plus the rarer
        direct `color` / `size` scalar fields. Empty if the site's JSON-LD
        just doesn't carry this - we don't invent it."""
        out: list[tuple[str, str]] = []
        props = n.get("additionalProperty")
        if isinstance(props, dict):
            props = [props]
        for p in props or []:
            if not isinstance(p, dict):
                continue
            name = p.get("name") or p.get("propertyID")
            value = p.get("value")
            if name and value not in (None, ""):
                out.append((str(name), str(value)))
        for key in ("color", "size"):
            v = n.get(key)
            for item in (v if isinstance(v, list) else [v] if v else []):
                out.append((key.capitalize(), str(item)))
        return out

    page_url = node.get("_page_url") or node.get("url") or ""
    offers = _first_offer(node)
    price = _num(offers.get("price") or offers.get("lowPrice"))
    high = _num(offers.get("highPrice")) or price
    in_stock = _offer_in_stock(offers)

    images_raw = node.get("image")
    if isinstance(images_raw, str):
        images = [images_raw]
    elif isinstance(images_raw, list):
        images = [i if isinstance(i, str) else i.get("url") for i in images_raw if i]
    else:
        images = []

    sku = node.get("sku") or node.get("productID") or ""
    uid = sku or hashlib.sha1(page_url.encode("utf-8")).hexdigest()[:16]

    # Real per-variant size/color: only present when a site's JSON-LD spells
    # out `hasVariant` (one nested Product per SKU) or `additionalProperty`
    # on the product itself. If neither exists, options/variants stay empty
    # and to_dart.py's title/keyword fallback takes over downstream - we
    # never guess a size/color here ourselves.
    variant_nodes = node.get("hasVariant")
    variant_nodes = variant_nodes if isinstance(variant_nodes, list) else ([variant_nodes] if isinstance(variant_nodes, dict) else [])

    order: list[str] = []
    values_by_name: dict[str, list[str]] = {}
    variant_records: list[dict[str, Any]] = []

    if variant_nodes:
        for vn in variant_nodes:
            if not isinstance(vn, dict):
                continue
            attrs = _attrs(vn) or _attrs(node)
            for name, _ in attrs:
                if name not in order:
                    order.append(name)
                    values_by_name[name] = []
            title_parts = []
            for name in order:
                val = next((v for n, v in attrs if n == name), "")
                title_parts.append(val)
                if val and val not in values_by_name[name]:
                    values_by_name[name].append(val)
            v_offers = _first_offer(vn)
            v_price = _num(v_offers.get("price"))
            variant_records.append({
                "sku": vn.get("sku") or vn.get("productID"),
                "title": " / ".join(title_parts),
                "price": v_price if v_price is not None else price,
                "available": _offer_in_stock(v_offers, default=in_stock),
            })
    else:
        attrs = _attrs(node)
        if attrs:
            for name, val in attrs:
                if name not in order:
                    order.append(name)
                    values_by_name[name] = []
                if val not in values_by_name[name]:
                    values_by_name[name].append(val)
            variant_records.append({
                "sku": sku,
                "title": " / ".join(values_by_name[n][0] for n in order),
                "price": price,
                "available": in_stock,
            })

    options = [{"name": n, "values": values_by_name[n], "position": i + 1} for i, n in enumerate(order)]
    variant_prices = [r["price"] for r in variant_records if r["price"] is not None]
    if variant_prices:
        price, high = min(variant_prices), max(variant_prices)
    if variant_records:
        in_stock = any(r["available"] for r in variant_records)

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
        "variants": variant_records,
        "attributes": {"options": options, "published_at": None, "shopify_updated_at": None},
        "source": "generic_jsonld",
        "scraped_at": datetime.now(timezone.utc).isoformat(),
    }
