# Product Aggregation Module (Module 6)

Fetches real-time product catalogs from major Pakistani fashion brands and
normalizes them into LibasAI's unified schema.

## Approach

Most major Pakistani brands run on **Shopify**, which exposes a public,
unauthenticated `/products.json` endpoint (paginated, `?limit=250&page=N`).
We use that instead of scraping rendered HTML — it's stable, structured, and
far less abusive to the source site. Non-Shopify brands (e.g. Khaadi) need a
dedicated adapter and are marked `type: custom` / `enabled: false` in
`brands.yaml`.

Brands are no longer hand-edited in `brands.yaml` - they live in a small
SQLite registry (`scraper/data/admin.db`) managed through the admin API /
`admin_app` Flutter panel (see `../admin_app/README.md`), which also knows how
to auto-detect a brand's platform (Shopify / WooCommerce / a generic
sitemap+JSON-LD fallback for everything else) from just its URL.

## Usage

```bash
pip install -r requirements.txt
python migrate_yaml.py            # 0. one-off: import brands.yaml into the DB
python run.py                     # 1. all enabled brands -> data/products.jsonl
python to_dart.py --per-brand 16  # 2. sample into lib/data.dart (keeps existing logoUrl)
python scrape_logos.py            # 3. patch brand logos into lib/data.dart

# or run the admin API + Flutter panel instead of the CLI:
uvicorn server.app:app --reload --port 8000
```

Output is JSONL (one product per line). Load into Postgres later or into
pandas for the recommendation spike.

## Files

| File | Role |
|---|---|
| `brands.yaml` | **Legacy** - the original static brand registry; superseded by `server/db.py`, kept for reference. `migrate_yaml.py` imports it once. |
| `server/db.py` | SQLite-backed brand registry + scrape job history |
| `server/detect.py` | Guesses a brand's platform (Shopify / WooCommerce / generic) from its URL |
| `server/app.py` | FastAPI admin API - brand CRUD, detect, scrape, publish (used by `../admin_app`) |
| `shopify_source.py` | Polite paginated fetch of `/products.json` |
| `woocommerce_source.py` | Polite paginated fetch of the WooCommerce Store API |
| `generic_source.py` | Sitemap crawl + schema.org JSON-LD extraction, for sites with neither API |
| `normalize.py` | Raw brand data (any of the three sources) -> unified record (typed cols + JSONB `attributes`) |
| `run.py` | CLI orchestrator - reads brands from the DB, dispatches to the right adapter |
| `to_dart.py` | Sample the JSONL into the Flutter app catalog (`lib/data.dart`) |
| `scrape_logos.py` | Scrape each brand's logo/favicon and patch `logoUrl` into `lib/data.dart` |
| `colors.py` | Extract dominant garment colours from a product photo (fallback for brands with no Color option) |

## Latest run

38,377 products across 10 brands (Sana Safinaz, Gul Ahmed, Beechtree,
Generation, Zellbury, Vanya, Mushq, Zeen, Zaaviay, Suffuse).
`to_dart.py` then samples 16/brand -> 160 real products with live Shopify CDN
images into the app.

**Sapphire**: Shopify store but `/products.json` is disabled (404) - needs an
HTML/sitemap adapter. Marked `type: custom`, `enabled: false`.

## Unified record

Typed fields every product has (`product_uid`, `brand_id`, `title`,
`price_min/max`, `url`, `images`, `in_stock`) plus an `attributes` JSONB blob
for variable per-brand fields — matches the planned Postgres design.

## Data fidelity (what's real vs. derived)

| Field | Source |
|---|---|
| title, price, images, URL, in-stock | real, straight from `/products.json` |
| `sizes` | real - Shopify "Size" option values (letters normalised + ordered); falls back to `One Size` / `Unstitched` / `S,M,L` when a product has no size option |
| `inStockSizes` | real - per-variant `available` flag mapped back to its size token |
| `colors` | best available: (1) Shopify "Color" option -> hex, (2) colour word in title, (3) dominant colours sampled from the product photo (`colors.py`, cached in `data/color_cache.json`), (4) empty -> the app hides the colour section instead of guessing |
| category, occasion | derived by keyword-matching title/tags/product_type |

## Notes / TODO

- `brand_tier` feeds the CCP fairness re-ranking later (protect small/emerging
  brands' visibility). Add real small brands to `brands.yaml` as they're onboarded.
- Currency is taken from `brands.yaml`, not the endpoint (some stores localize
  the `/products.json` price display by IP).
- Respect each brand's `robots.txt` / ToS; keep the 1s inter-page delay.
- Next: incremental sync (dedupe on `product_uid`, track `shopify_updated_at`),
  a Khaadi adapter, and a scheduled refresh job.
