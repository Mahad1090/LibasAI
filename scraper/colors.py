"""Extract dominant garment colours from a product photo.

Used only when a brand doesn't expose colour as a Shopify variant option
(Sana Safinaz, Gul Ahmed, Generation ...). Downloads the image, ignores the
near-white studio background and very dark shadows, quantises the rest, and
returns the most common swatches as hex.

Results are cached in data/color_cache.json keyed by image URL.
"""
from __future__ import annotations

import io
import json
from pathlib import Path

import httpx
from PIL import Image

CACHE = Path(__file__).parent / "data" / "color_cache.json"
UA = "Mozilla/5.0 (LibasAI-Aggregator; FYP research)"


def _load_cache() -> dict[str, list[str]]:
    try:
        return json.loads(CACHE.read_text())
    except (FileNotFoundError, ValueError):
        return {}


def _save_cache(cache: dict) -> None:
    CACHE.parent.mkdir(parents=True, exist_ok=True)
    CACHE.write_text(json.dumps(cache, indent=0))


def _is_background(r: int, g: int, b: int) -> bool:
    mx, mn = max(r, g, b), min(r, g, b)
    if mx > 238 and mx - mn < 14:      # near-white / paper backdrop
        return True
    if mx < 28:                        # near-black shadow
        return True
    if mx - mn < 10 and 90 < mx < 200:  # flat grey wall
        return True
    return False


def dominant_colors(image_url: str, *, n: int = 3, client: httpx.Client | None = None) -> list[str]:
    own = client is None
    client = client or httpx.Client(headers={"User-Agent": UA}, timeout=25, follow_redirects=True)
    try:
        resp = client.get(image_url)
        resp.raise_for_status()
        im = Image.open(io.BytesIO(resp.content)).convert("RGB")
    except Exception:
        return []
    finally:
        if own:
            client.close()

    # centre-crop a bit (edges are usually backdrop) then shrink
    w, h = im.size
    im = im.crop((int(w * 0.15), int(h * 0.10), int(w * 0.85), int(h * 0.95)))
    im = im.resize((90, 120))
    q = im.quantize(colors=12, method=Image.Quantize.FASTOCTREE)
    palette = q.getpalette()
    counts = sorted(q.getcolors(), reverse=True)  # (count, index)

    out: list[str] = []
    for count, idx in counts:
        r, g, b = palette[idx * 3: idx * 3 + 3]
        if _is_background(r, g, b):
            continue
        hex_ = f"#{r:02X}{g:02X}{b:02X}"
        if all(_dist(hex_, o) > 40 for o in out):  # skip near-duplicates
            out.append(hex_)
        if len(out) >= n:
            break
    return out


def _dist(a: str, b: str) -> float:
    ar, ag, ab = int(a[1:3], 16), int(a[3:5], 16), int(a[5:7], 16)
    br, bg, bb = int(b[1:3], 16), int(b[3:5], 16), int(b[5:7], 16)
    return ((ar - br) ** 2 + (ag - bg) ** 2 + (ab - bb) ** 2) ** 0.5


_cache = _load_cache()


def dominant_colors_cached(image_url: str, client: httpx.Client | None = None) -> list[str]:
    if image_url not in _cache:
        _cache[image_url] = dominant_colors(image_url, client=client)
        _save_cache(_cache)
    return _cache[image_url]
