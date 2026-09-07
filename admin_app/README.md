# LibasAI Operations Admin Portal

The comprehensive internal operations and management portal for **LibasAI**, separate from the customer-facing `libasai` mobile app. Built for platform administrators, catalog managers, and tailor network operations for the FAST-NUCES Final Year Project (FYP).

Shares the unified luxury brand design system (`theme.dart` / `widgets.dart`) and communicates with the FastAPI administrative backend in `../scraper/server/app.py`.

---

## Running the Admin Portal

### 1. (Optional) Start the FastAPI Backend
From `scraper/`:
```bash
pip install -r requirements.txt
python migrate_yaml.py        # first time only - seeds the brand DB
uvicorn server.app:app --reload --port 8000
```

### 2. Launch the Admin Portal
From `admin_app/`:
```bash
flutter pub get
flutter run -d chrome --web-port 3008
```

> **Dual Execution Mode**: The Admin Portal automatically connects to `http://127.0.0.1:8000` when available, and seamlessly falls back to pre-seeded authentic platform data if run standalone during presentations.

---

## Core Operations Modules

### 1. Executive Dashboard (`dashboard`)
- **Key Performance Indicators**: Total products indexed (168+), active brand partners (15+), verified master tailors (6), active stitching requests (3), and discovery outbound clicks (1,420+).
- **Outbound Traffic Breakdown**: Visual metrics tracking customer redirection volume per brand partner (Sana Safinaz, J., Beechtree, Vanya, Amir Adnan, Charcoal).
- **Emerging Designer Fair Share**: Real-time gauge demonstrating Competition Commission of Pakistan (CCP) fair market compliance (48.5% impression share).
- **Trending Search Queries**: Live audit of top natural language shopper searches.

### 2. Brand & Scraper Registry (`brands`)
- **Platform Auto-Detection**: Probes domains for Shopify (`/products.json`), WooCommerce Store API, or XML sitemaps.
- **On-Demand & Bulk Scraping**: Background task orchestrator with real-time log terminal streaming.
- **Publish to App**: One-click pipeline compilation (`to_dart.py` + `scrape_logos.py`) into customer app data.

### 3. Master Tailor (Darzi) Network (`tailors`)
- **Atelier Verification**: Approve, inspect, or suspend verified master darzis across Lahore, Karachi, Islamabad, Rawalpindi, and Faisalabad.
- **Availability Toggles**: Switch tailor status (*Accepting Orders* ➔ *At Capacity* ➔ *Paused*).
- **Rate Card Inspector**: Transparent pricing for Kurta Shalwar, Waistcoats, Lawn Suits, and Bridal Formals.

### 4. Bespoke Stitching Order Ledger (`orders`)
- **Central Order Registry**: Track customer requests (`LB-ST-XXXXX`) with client names, contact details, and doorstep addresses.
- **Interactive 5-Stage Stepper**:
  1. *Fabric Received & Verified*
  2. *Cutting & Marking*
  3. *Stitching & Overlock*
  4. *Quality & Press Inspection*
  5. *Dispatched / Delivered*
- **One-Click Stage Advancement**: Operational controls to advance stitching progress.

### 5. Master Catalog & Inventory Oversight (`catalog`)
- **Multi-Brand Product Browser**: Live search by title, SKU, or keyword.
- **Faceted Filters**: Gender (`Men` / `Women`), Brand, and Category chips.
- **Outbound Link Integrity**: Automated HTTP status indicator (200 OK) for brand checkout links.

### 6. AI Stylist & Search Governance (`ai_tuning`)
- **System Prompt Config**: View and tune the AI concierge's system instructions and cultural persona.
- **Pakistani Fashion Taxonomy**: Manage local terms (*Latha*, *Boski*, *Ban Collar*, *Organza*, *Jamawar*, *Ghera*).
- **Zero-Result Query Gap Audit**: Unmet customer search queries logged to guide upcoming scraper cycles.
