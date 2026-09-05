"""Fetch products from a WooCommerce storefront's public Store API.

WooCommerce ships a public, unauthenticated "Store API" (used by its own
block-based cart/checkout UI) at /wp-json/wc/store/v1/products. It's
paginated the same way Shopify's /products.json is - no API key needed,
mirrors shopify_source.py's shape so run.py can treat every adapter the same.
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


def fetch_products(base_url: str, *, max_pages: int = 80, delay: float = 0.5) -> Iterator[dict]:
    """Yield raw WooCommerce Store API product dicts, politely paginated."""
    headers = {"User-Agent": USER_AGENT, "Accept": "application/json"}
    with httpx.Client(headers=headers, timeout=30, follow_redirects=True) as client:
        for page in range(1, max_pages + 1):
            products = _get_page(client, base_url, page)
            if not products:
                return
            yield from products
            time.sleep(delay)
