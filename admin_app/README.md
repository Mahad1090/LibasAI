# LibasAI Admin

Internal tool for managing scraped brands - separate from the customer-facing
`libasai` app (different audience, different release cadence; the customer
app should never ship admin/write capability). Shares the same visual design
(`lib/theme.dart` / `lib/widgets.dart` are trimmed copies of the customer
app's, see comments there) but talks to its own backend: the FastAPI admin
API in `../scraper/server/`.

## Run it

1. Start the backend (from `scraper/`):
   ```bash
   pip install -r requirements.txt
   python migrate_yaml.py        # first time only - seeds the brand DB
   uvicorn server.app:app --reload --port 8000
   ```
2. Start this app, pointed at that server (default is `http://127.0.0.1:8000`):
   ```bash
   flutter pub get
   flutter run -d chrome --dart-define=API_BASE=http://127.0.0.1:8000
   ```

## What it does

- **Add brand** - paste a name + URL, hit "Add & detect platform"; the
  backend probes the site (Shopify `/products.json`, WooCommerce Store API,
  or a sitemap.xml fallback) and returns a guess you can override before
  saving.
- **Detect** / **Scrape** per brand, or **Scrape all** enabled brands - runs
  in the background on the server; a bottom sheet polls the job and streams
  its log.
- **Publish to app** - runs `to_dart.py` + `scrape_logos.py` against the
  customer app's `lib/data.dart`, the same two steps documented in
  `scraper/README.md`, as one button.
