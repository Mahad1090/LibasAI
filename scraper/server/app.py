"""Admin API for the dynamic scraper: brand registry (CRUD), platform
detection, scrape jobs, and publishing scraped data into the customer app.

Run from inside scraper/:
    pip install -r requirements.txt
    uvicorn server.app:app --reload --port 8000

The admin_app Flutter web project is the intended client, but every route
below is plain JSON and works fine from curl/Postman too.
"""
from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path
from typing import Any, Optional

from fastapi import BackgroundTasks, FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from run import ADAPTERS, scrape_brand
from server import db
from server.detect import detect_platform

SCRAPER_DIR = Path(__file__).resolve().parent.parent
if str(SCRAPER_DIR) not in sys.path:
    sys.path.insert(0, str(SCRAPER_DIR))
PRODUCTS_PATH = SCRAPER_DIR / "data" / "products.jsonl"
WEBSITE_DIR = SCRAPER_DIR.parent / "website"

_CATALOG_CACHE: list[dict[str, Any]] = []


def get_or_load_catalog(force_rebuild: bool = False) -> list[dict[str, Any]]:
    global _CATALOG_CACHE
    catalog_file = WEBSITE_DIR / "live_catalog.json"

    if force_rebuild or not _CATALOG_CACHE:
        if catalog_file.exists() and not force_rebuild:
            try:
                with catalog_file.open("r", encoding="utf-8") as f:
                    data = json.load(f)
                    if isinstance(data, list) and len(data) > 0:
                        _CATALOG_CACHE = data
            except Exception:
                pass

        if not _CATALOG_CACHE or force_rebuild:
            try:
                from export_live_catalog import build_catalog_items
                _CATALOG_CACHE = build_catalog_items(per_brand=28)
                catalog_file.parent.mkdir(parents=True, exist_ok=True)
                with catalog_file.open("w", encoding="utf-8") as f:
                    json.dump(_CATALOG_CACHE, f, indent=2, ensure_ascii=False)
            except Exception as e:
                print(f"Error building live catalog: {e}")

    # Filter by currently enabled brands in SQLite DB
    try:
        active_brands = {b["name"].lower().strip() for b in db.list_brands(enabled_only=True)}
        if active_brands:
            return [x for x in _CATALOG_CACHE if x.get("brand", "").lower().strip() in active_brands]
    except Exception:
        pass

    return _CATALOG_CACHE

app = FastAPI(title="LibasAI Scraper Admin API")
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # local admin tool; tighten if ever deployed
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.on_event("startup")
def _startup() -> None:
    db.init_db()


# ---- schemas ----------------------------------------------------------------

class BrandCreate(BaseModel):
    name: str
    base_url: str
    type: str = "unknown"
    tier: str = "emerging"
    currency: str = "PKR"
    enabled: bool = True


class BrandUpdate(BaseModel):
    name: Optional[str] = None
    base_url: Optional[str] = None
    type: Optional[str] = None
    tier: Optional[str] = None
    currency: Optional[str] = None
    enabled: Optional[bool] = None


# ---- brands -------------------------------------------------------------------

@app.get("/brands")
def get_brands() -> list[dict[str, Any]]:
    return db.list_brands()


@app.post("/brands")
def create_brand(body: BrandCreate) -> dict[str, Any]:
    if body.type not in (*ADAPTERS.keys(), "unknown"):
        raise HTTPException(400, "invalid type")
    return db.insert_brand(
        name=body.name,
        base_url=body.base_url,
        type_=body.type,
        tier=body.tier,
        currency=body.currency,
        enabled=body.enabled,
    )


@app.patch("/brands/{brand_id}")
def patch_brand(brand_id: str, body: BrandUpdate) -> dict[str, Any]:
    if db.get_brand(brand_id) is None:
        raise HTTPException(404, "brand not found")
    fields = {k: v for k, v in body.model_dump().items() if v is not None}
    if "type" in fields and fields["type"] not in (*ADAPTERS.keys(), "unknown"):
        raise HTTPException(400, "invalid type")
    res = db.update_brand(brand_id, **fields)
    if "enabled" in fields:
        try:
            get_or_load_catalog(force_rebuild=True)
        except Exception as e:
            print(f"Error rebuilding catalog on brand toggle: {e}")
    return res


@app.delete("/brands/{brand_id}")
def remove_brand(brand_id: str) -> dict[str, str]:
    if db.get_brand(brand_id) is None:
        raise HTTPException(404, "brand not found")
    db.delete_brand(brand_id)
    try:
        get_or_load_catalog(force_rebuild=True)
    except Exception as e:
        print(f"Error rebuilding catalog on brand removal: {e}")
    return {"status": "deleted"}


@app.post("/brands/{brand_id}/detect")
def detect_brand(brand_id: str) -> dict[str, Any]:
    brand = db.get_brand(brand_id)
    if brand is None:
        raise HTTPException(404, "brand not found")
    result = detect_platform(brand["base_url"])
    return db.update_brand(
        brand_id, type=result.type, detect_note=result.note, detected_at=db.now()
    )


# ---- scrape jobs --------------------------------------------------------------

def _rewrite_products_for_brands(brand_ids: set[str], new_records: list[dict]) -> None:
    """Replace any existing rows for `brand_ids` in products.jsonl with
    `new_records`, leaving every other brand's rows untouched."""
    PRODUCTS_PATH.parent.mkdir(parents=True, exist_ok=True)
    kept: list[str] = []
    if PRODUCTS_PATH.exists():
        with PRODUCTS_PATH.open(encoding="utf-8") as fh:
            for line in fh:
                if not line.strip():
                    continue
                try:
                    rec = json.loads(line)
                except json.JSONDecodeError:
                    continue
                if rec.get("brand_id") not in brand_ids:
                    kept.append(line.rstrip("\n"))
    with PRODUCTS_PATH.open("w", encoding="utf-8") as fh:
        for line in kept:
            fh.write(line + "\n")
        for rec in new_records:
            fh.write(json.dumps(rec, ensure_ascii=False) + "\n")


def _run_scrape_job(job_id: int, brand_ids: list[str]) -> None:
    brands = [b for b in db.list_brands(enabled_only=True) if b["id"] in brand_ids]
    all_records: list[dict] = []
    log_lines: list[str] = []

    def log(line: str) -> None:
        log_lines.append(line)
        db.append_job_log(job_id, line)

    try:
        for brand in brands:
            log(f"- {brand['name']} ({brand['base_url']}) [{brand['type']}]")
            try:
                recs = scrape_brand(brand, log=log)
            except Exception as e:  # noqa: BLE001
                log(f"  ! {brand['id']}: FAILED ({e})")
                continue
            log(f"  {len(recs)} products")
            all_records.extend(recs)
        _rewrite_products_for_brands(set(brand_ids), all_records)
        db.finish_job(job_id, status="success", products_count=len(all_records), log="\n".join(log_lines))
    except Exception as e:  # noqa: BLE001
        log(f"! job failed: {e}")
        db.finish_job(job_id, status="failed", products_count=len(all_records), log="\n".join(log_lines))


@app.post("/brands/{brand_id}/scrape")
def scrape_one(brand_id: str, tasks: BackgroundTasks) -> dict[str, Any]:
    brand = db.get_brand(brand_id)
    if brand is None:
        raise HTTPException(404, "brand not found")
    job_id = db.create_job(brand_id)
    tasks.add_task(_run_scrape_job, job_id, [brand_id])
    return {"job_id": job_id}


@app.post("/scrape-all")
def scrape_all(tasks: BackgroundTasks) -> dict[str, Any]:
    brand_ids = [b["id"] for b in db.list_brands(enabled_only=True)]
    if not brand_ids:
        raise HTTPException(400, "no enabled brands")
    job_id = db.create_job(None)
    tasks.add_task(_run_scrape_job, job_id, brand_ids)
    return {"job_id": job_id, "brands": brand_ids}


@app.get("/jobs")
def get_jobs() -> list[dict[str, Any]]:
    return db.list_jobs()


@app.get("/jobs/{job_id}")
def get_job(job_id: int) -> dict[str, Any]:
    job = db.get_job(job_id)
    if job is None:
        raise HTTPException(404, "job not found")
    return job


# ---- publish to the customer app -----------------------------------------------

@app.post("/publish")
def publish() -> dict[str, Any]:
    """Run to_dart.py then scrape_logos.py against lib/data.dart, and export
    a live catalog snapshot for the marketing website."""
    results = {}
    for script in ("to_dart.py", "scrape_logos.py"):
        proc = subprocess.run(
            [sys.executable, script],
            cwd=SCRAPER_DIR,
            capture_output=True,
            text=True,
            timeout=600,
        )
        results[script] = {
            "returncode": proc.returncode,
            "stdout": proc.stdout[-4000:],
            "stderr": proc.stderr[-4000:],
        }
        if proc.returncode != 0:
            raise HTTPException(500, detail=results)

    # Also export live catalog snapshot for website and update in-memory cache
    try:
        catalog_items = get_or_load_catalog(force_rebuild=True)
        results["website_catalog_export"] = f"Exported {len(catalog_items)} items to live_catalog.json"
    except Exception as e:
        results["website_catalog_export"] = f"Warning: {e}"

    return results


# ---- operational & dashboard endpoints ----------------------------------------

@app.get("/stats")
def get_stats() -> dict[str, Any]:
    brands = db.list_brands()
    lux = sum(1 for b in brands if b.get("tier") in ("established", "luxury"))
    em = len(brands) - lux

    prod_count = 0
    if PRODUCTS_PATH.exists():
        with PRODUCTS_PATH.open(encoding="utf-8") as fh:
            for line in fh:
                if line.strip():
                    prod_count += 1

    tailors = db.list_tailors()
    orders = db.list_orders()
    brand_clicks = db.get_brand_clicks()
    total_clicks = sum(brand_clicks.values())
    queries = db.get_search_queries()

    return {
        "total_products": prod_count,
        "total_brands": len(brands),
        "luxury_brands": lux,
        "emerging_brands": em,
        "active_tailors": len(tailors),
        "active_orders": len(orders),
        "outbound_clicks": total_clicks,
        "emerging_share_percent": round((em / len(brands) * 100) if brands else 48.5, 1),
        "brand_clicks": brand_clicks,
        "trending_queries": queries,
    }


@app.get("/tailors")
def get_tailors() -> list[dict[str, Any]]:
    return db.list_tailors()


@app.patch("/tailors/{tailor_id}")
def patch_tailor(tailor_id: str, body: dict[str, Any]) -> dict[str, Any]:
    updated = db.update_tailor(tailor_id, **body)
    if updated is None:
        raise HTTPException(404, "tailor not found")
    return updated


@app.get("/orders")
def get_orders() -> list[dict[str, Any]]:
    return db.list_orders()


@app.patch("/orders/{order_id}")
def patch_order(order_id: str, body: dict[str, Any]) -> dict[str, Any]:
    updated = db.update_order(order_id, **body)
    if updated is None:
        raise HTTPException(404, "order not found")
    return updated


@app.get("/catalog")
def get_catalog(
    q: Optional[str] = None,
    brand: Optional[str] = None,
    gender: Optional[str] = None,
    category: Optional[str] = None,
    limit: int = 600,
) -> list[dict[str, Any]]:
    items = get_or_load_catalog()
    results = []

    ql = q.lower().strip() if q else ""
    bl = brand.lower().strip() if (brand and brand.lower() != "all") else ""
    gl = gender.lower().strip() if (gender and gender.lower() != "all") else ""
    cl = category.lower().strip() if (category and category.lower() != "all") else ""

    for item in items:
        if bl and bl not in item.get("brand", "").lower():
            continue
        if gl and item.get("gender", "").lower() != gl:
            continue
        if cl:
            i_cat = item.get("category", "").lower()
            i_tags = item.get("tags", [])
            if cl != i_cat and cl not in i_tags:
                continue
        if ql:
            haystack = f"{item.get('title','')} {item.get('brand','')} {' '.join(item.get('tags',[]))}".lower()
            if ql not in haystack:
                continue
        results.append(item)
        if len(results) >= limit:
            break

    return results


@app.get("/taxonomy")
def get_taxonomy() -> list[dict[str, Any]]:
    return db.list_taxonomy()


class TaxonomyCreate(BaseModel):
    id: Optional[str] = None
    alias: str
    canonical: str
    category: str
    weight: float = 1.0


@app.post("/taxonomy")
def create_taxonomy(body: TaxonomyCreate) -> dict[str, Any]:
    tid = body.id or f"t_{db.now()[-6:]}"
    return db.insert_taxonomy(
        id_=tid,
        alias=body.alias,
        canonical=body.canonical,
        category=body.category,
        weight=body.weight,
    )


@app.delete("/taxonomy/{term_id}")
def delete_taxonomy(term_id: str) -> dict[str, str]:
    db.delete_taxonomy(term_id)
    return {"status": "deleted"}


@app.post("/clicks/{brand_name}")
def click_brand(brand_name: str) -> dict[str, Any]:
    db.record_brand_click(brand_name)
    return {"status": "recorded", "clicks": db.get_brand_clicks().get(brand_name, 1)}


@app.get("/fairness")
def get_fairness() -> dict[str, Any]:
    return db.get_fairness_config()


@app.post("/fairness")
def post_fairness(body: dict[str, Any]) -> dict[str, Any]:
    return db.save_fairness_config(body)



