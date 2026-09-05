"""Guess which e-commerce platform a brand's site runs on, from just its URL.

Cheap, read-only, short-timeout probes - never fetches a full catalog here,
that's what the adapters (`shopify_source.py` / `woocommerce_source.py` /
`generic_source.py`) do once a type is confirmed.
"""
from __future__ import annotations

from dataclasses import dataclass

import httpx

UA = "LibasAI-Aggregator/0.1 (FYP research crawler; platform detection)"
TIMEOUT = 10


@dataclass
class DetectResult:
    type: str  # shopify | woocommerce | generic | unknown
    note: str  # human-readable evidence, shown in the admin UI


def detect_platform(base_url: str) -> DetectResult:
    base = base_url.rstrip("/")
    headers = {"User-Agent": UA, "Accept": "application/json"}
    with httpx.Client(headers=headers, timeout=TIMEOUT, follow_redirects=True) as client:
        # 1. Shopify's public storefront endpoint.
        try:
            r = client.get(f"{base}/products.json", params={"limit": 1})
            if r.status_code == 200 and "products" in r.json():
                return DetectResult("shopify", "found /products.json (Shopify storefront API)")
        except Exception:
            pass

        # 2. WooCommerce's public Store API.
        try:
            r = client.get(f"{base}/wp-json/wc/store/v1/products", params={"per_page": 1})
            if r.status_code == 200 and isinstance(r.json(), list):
                return DetectResult(
                    "woocommerce", "found /wp-json/wc/store/v1/products (WooCommerce Store API)"
                )
        except Exception:
            pass

        # 2b. Some WooCommerce/WordPress sites block that route but still expose
        # the REST API root - check its namespace list.
        try:
            r = client.get(f"{base}/wp-json/")
            if r.status_code == 200:
                namespaces = r.json().get("namespaces", [])
                if any("wc/store" in n for n in namespaces):
                    return DetectResult(
                        "woocommerce", "found wc/store namespace at /wp-json/"
                    )
                if namespaces:
                    return DetectResult(
                        "generic",
                        "WordPress site (/wp-json/ present) without a WooCommerce Store API "
                        "namespace - falling back to sitemap + JSON-LD",
                    )
        except Exception:
            pass

        # 3. Generic fallback: is there a sitemap we can crawl for product URLs?
        for path in ("/sitemap.xml", "/sitemap_index.xml"):
            try:
                r = client.get(f"{base}{path}")
                head = r.content[:2000]
                if r.status_code == 200 and (b"<urlset" in head or b"<sitemapindex" in head):
                    return DetectResult("generic", f"found {path} - will use sitemap + JSON-LD scraping")
            except Exception:
                continue

    return DetectResult(
        "unknown", "no /products.json, WooCommerce Store API, or sitemap.xml found - needs manual setup"
    )
