"""Fetch products from a Shopify storefront's public /products.json endpoint.

Shopify exposes /products.json on every storefront. It is paginated
(?limit=250&page=N) and returns until an empty list. This is a documented,
unauthenticated endpoint - no HTML scraping, no headless browser.
"""
from __future__ import annotations

import time
from typing import Iterator

import httpx
from tenacity import retry, stop_after_attempt, wait_exponential

PAGE_SIZE = 250
USER_AGENT = (
    "LibasAI-Aggregator/0.1 (FYP research crawler; FAST-NUCES; "
    "contact i230537@isb.nu.edu.pk)"
)


@retry(stop=stop_after_attempt(4), wait=wait_exponential(multiplier=1, min=2, max=30))
def _get_page(client: httpx.Client, base_url: str, page: int) -> list[dict]:
    url = f"{base_url.rstrip('/')}/products.json"
    resp = client.get(url, params={"limit": PAGE_SIZE, "page": page})
    # Some stores (e.g. Sapphire) redirect an out-of-range page to /404 instead
    # of returning an empty product list - treat that as "end of catalog".
    if resp.status_code == 404:
        return []
    resp.raise_for_status()
    return resp.json().get("products", [])


def fetch_products(base_url: str, *, max_pages: int = 80, delay: float = 0.5) -> Iterator[dict]:
    """Yield raw Shopify product dicts for a storefront, politely paginated."""
    headers = {"User-Agent": USER_AGENT, "Accept": "application/json"}
    with httpx.Client(headers=headers, timeout=30, follow_redirects=True) as client:
        for page in range(1, max_pages + 1):
            products = _get_page(client, base_url, page)
            if not products:
                return
            yield from products
            time.sleep(delay)  # be a good citizen; avoid hammering the store
