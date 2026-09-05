"""Fetch products from an arbitrary custom-built storefront (no Shopify/
WooCommerce API available).

Strategy: crawl the site's sitemap.xml (recursing one level into a sitemap
index) for candidate product URLs, fetch each page, and pull structured
schema.org `Product` data out of its embedded JSON-LD (`<script
type="application/ld+json">`). No headless browser, no HTML scraping of
prices/titles - if a page has no JSON-LD we skip it rather than guess.
"""
from __future__ import annotations

import json
import re
import time
from typing import Any, Iterator
from xml.etree import ElementTree as ET

import httpx
from tenacity import retry, stop_after_attempt, wait_exponential

USER_AGENT = (
    "LibasAI-Aggregator/0.1 (FYP research crawler; FAST-NUCES; "
    "contact i230537@isb.nu.edu.pk)"
)
MAX_PAGES = 300
SITEMAP_PATHS = ("/sitemap.xml", "/sitemap_index.xml")

# URL shapes that usually mean "this is a single product page", so we don't
# waste requests fetching every blog post / collection page in the sitemap.
_PRODUCT_URL_HINTS = re.compile(r"/(product|products|shop|item)/", re.I)

_JSONLD_RE = re.compile(
    r'<script[^>]+type=["\']application/ld\+json["\'][^>]*>(.*?)</script>',
    re.I | re.S,
)


@retry(stop=stop_after_attempt(3), wait=wait_exponential(multiplier=1, min=2, max=20))
def _get(client: httpx.Client, url: str) -> httpx.Response:
    return client.get(url)


def _sitemap_urls(client: httpx.Client, base_url: str) -> list[str]:
    """Return <loc> URLs from the site's sitemap, following one level of
    sitemap-index nesting."""
    base = base_url.rstrip("/")
    for path in SITEMAP_PATHS:
        try:
            resp = _get(client, f"{base}{path}")
        except Exception:
            continue
        if resp.status_code != 200:
            continue
        try:
            root = ET.fromstring(resp.content)
        except ET.ParseError:
            continue

        tag = root.tag.rsplit("}", 1)[-1]
        locs = [el.text.strip() for el in root.iter() if el.tag.endswith("loc") and el.text]

        if tag == "sitemapindex":
            # one level of nesting: fetch each child sitemap and collect its URLs
            urls: list[str] = []
            for sm_url in locs[:20]:  # cap fan-out
                try:
                    child = _get(client, sm_url)
                    child_root = ET.fromstring(child.content)
                    urls.extend(
                        el.text.strip()
                        for el in child_root.iter()
                        if el.tag.endswith("loc") and el.text
                    )
                except Exception:
                    continue
            return urls
        return locs
    return []


def _extract_products(html: str) -> list[dict[str, Any]]:
    """Pull schema.org Product objects out of a page's JSON-LD blocks."""
    found: list[dict[str, Any]] = []
    for block in _JSONLD_RE.findall(html):
        try:
            data = json.loads(block.strip())
        except (json.JSONDecodeError, ValueError):
            continue
        candidates = data if isinstance(data, list) else [data]
        for item in candidates:
            if not isinstance(item, dict):
                continue
            graph = item.get("@graph")
            nodes = graph if isinstance(graph, list) else [item]
            for node in nodes:
                if isinstance(node, dict) and _is_product(node):
                    found.append(node)
    return found


def _is_product(node: dict[str, Any]) -> bool:
    t = node.get("@type")
    types = t if isinstance(t, list) else [t]
    return any(isinstance(x, str) and x.lower() == "product" for x in types)


def fetch_products(
    base_url: str, *, max_pages: int = MAX_PAGES, delay: float = 1.0
) -> Iterator[dict[str, Any]]:
    """Yield (jsonld_product, page_url) pairs as dicts with a `_page_url` key,
    for `normalize.normalize_generic` to consume."""
    headers = {"User-Agent": USER_AGENT, "Accept": "text/html,application/xhtml+xml"}
    with httpx.Client(headers=headers, timeout=30, follow_redirects=True) as client:
        urls = _sitemap_urls(client, base_url)
        if not urls:
            return
        # prefer URLs that look like product pages; if none match the
        # heuristic, fall back to trying the sitemap as-is (capped) rather
        # than yielding nothing.
        product_urls = [u for u in urls if _PRODUCT_URL_HINTS.search(u)] or urls
        seen = 0
        for url in product_urls:
            if seen >= max_pages:
                return
            try:
                resp = _get(client, url)
                if resp.status_code != 200:
                    continue
                for product in _extract_products(resp.text):
                    product["_page_url"] = url
                    yield product
            except Exception:
                continue
            finally:
                seen += 1
                time.sleep(delay)
