"""Fetch products from a WooCommerce storefront's public Store API.

WooCommerce ships a public, unauthenticated "Store API" (used by its own
block-based cart/checkout UI) at /wp-json/wc/store/v1/products. It's
paginated the same way Shopify's /products.json is - no API key needed,
mirrors shopify_source.py's shape so run.py can treat every adapter the same.

The product-list endpoint only gives a "variable" product's *possible*
attribute combinations, not real per-variant price/stock - for that we hit
the dedicated (also public, unauthenticated) per-product variations endpoint:
/wp-json/wc/store/v1/products/{id}/variations. One extra request per variable
product (simple products need none), same politeness delay as list pages.
"""
from __future__ import annotations

import time
from typing import Iterator

import httpx
from tenacity import retry, stop_after_attempt, wait_exponential

PAGE_SIZE = 100
USER_AGENT = (
    "LibasAI-Aggregator/0.1 (FYP research crawler; FAST-NUCES; "
    "contact i230537@isb.nu.edu.pk)"
)


@retry(stop=stop_after_attempt(4), wait=wait_exponential(multiplier=1, min=2, max=30))
def _get_page(client: httpx.Client, base_url: str, page: int) -> list[dict]:
    url = f"{base_url.rstrip('/')}/wp-json/wc/store/v1/products"
    resp = client.get(url, params={"per_page": PAGE_SIZE, "page": page})
    if resp.status_code == 404:
        return []
    resp.raise_for_status()
    data = resp.json()
    return data if isinstance(data, list) else []


@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=20))
def _get_variations(client: httpx.Client, base_url: str, product_id) -> list[dict]:
    url = f"{base_url.rstrip('/')}/wp-json/wc/store/v1/products/{product_id}/variations"
    resp = client.get(url)
    if resp.status_code == 404:
        return []
    resp.raise_for_status()
    data = resp.json()
    return data if isinstance(data, list) else []


def fetch_products(base_url: str, *, max_pages: int = 80, delay: float = 0.5) -> Iterator[dict]:
    """Yield raw WooCommerce Store API product dicts, politely paginated.

    A "variable" product gets a `_variations_detail` key attached with the
    real per-variant price/sku/stock from the variations endpoint - see
    normalize.normalize_woocommerce for how that's consumed.
    """
    headers = {"User-Agent": USER_AGENT, "Accept": "application/json"}
    with httpx.Client(headers=headers, timeout=30, follow_redirects=True) as client:
        for page in range(1, max_pages + 1):
            products = _get_page(client, base_url, page)
            if not products:
                return
            for product in products:
                is_variable = product.get("type") == "variable" or bool(product.get("variations"))
                if is_variable:
                    try:
                        product["_variations_detail"] = _get_variations(client, base_url, product["id"])
                    except Exception:
                        product["_variations_detail"] = []
                    time.sleep(delay)
                yield product
            time.sleep(delay)
