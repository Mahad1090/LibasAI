"""Scrape a logo image URL for each brand and patch it into lib/data.dart.

Strategy per brand homepage:
  1. <link rel="apple-touch-icon"> / <link rel="icon"> (usually the brand mark)
  2. og:image / twitter:image
  3. a header <img> whose src/alt/class hints "logo"
  4. fall back to Google's favicon service

Usage: python scrape_logos.py
"""
from __future__ import annotations

import re
from pathlib import Path
from urllib.parse import urljoin

import httpx
import yaml

ROOT = Path(__file__).resolve().parents[1]
DATA_DART = ROOT / "lib" / "data.dart"
UA = "Mozilla/5.0 (LibasAI-Aggregator; FYP research)"


def _abs(base: str, src: str) -> str:
    src = src.strip().strip("'\"")
    if src.startswith("//"):
        return "https:" + src
    return urljoin(base, src)


def _favicon_service(final: str) -> str:
    host = re.sub(r"^https?://", "", final).split("/")[0]
    return f"https://www.google.com/s2/favicons?domain={host}&sz=128"


def find_logo(base_url: str) -> str:
    r = httpx.get(base_url, headers={"User-Agent": UA}, follow_redirects=True, timeout=25)
    r.raise_for_status()
    html = r.text
    final = str(r.url)

    # Prefer a raster apple-touch-icon (square brand mark, renders in Flutter's
    # Image.network). SVG icons are skipped - Flutter can't decode them.
    for rel in ("apple-touch-icon", "apple-touch-icon-precomposed", "icon", "shortcut icon"):
        for m in re.finditer(
            rf'<link[^>]+rel=["\'][^"\']*{re.escape(rel)}[^"\']*["\'][^>]*>', html, re.I
        ):
            href = re.search(r'href=["\']([^"\']+)["\']', m.group(0), re.I)
            if not href:
                continue
            url = _abs(final, href.group(1))
            if not url.lower().split("?")[0].endswith((".svg", ".ico")):
                url = url.replace("http://", "https://")
                # Shopify CDN serves an upscaled copy if we ask for it
                url = re.sub(r"([?&](?:height|width))=\d+", r"\1=192", url)
                return url

    return _favicon_service(final)


def main() -> None:
    brands = yaml.safe_load((Path(__file__).parent / "brands.yaml").read_text())["brands"]
    logos: dict[str, str] = {}
    for b in brands:
        try:
            url = find_logo(b["base_url"])
            logos[b["id"]] = url
            print(f"  {b['id']:<14} {url}")
        except Exception as e:  # noqa: BLE001
            print(f"  {b['id']:<14} FAILED ({e})")

    src = DATA_DART.read_text(encoding="utf-8")

    def repl(m: re.Match) -> str:
        bid = m.group(1)
        if bid not in logos:
            return m.group(0)
        logo = logos[bid].replace("'", "\\'")
        line = m.group(0)
        if "logoUrl:" in line:
            return re.sub(r"logoUrl: '[^']*'", f"logoUrl: '{logo}'", line)
        return line[:-1] + f", logoUrl: '{logo}')"

    src = re.sub(r"Brand\('([a-z_]+)'[^\n]*\)", repl, src)
    DATA_DART.write_text(src, encoding="utf-8")
    print(f"patched {len(logos)} logos -> {DATA_DART}")


if __name__ == "__main__":
    main()
