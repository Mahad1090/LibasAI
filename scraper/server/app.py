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
PRODUCTS_PATH = SCRAPER_DIR / "data" / "products.jsonl"

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
    return db.update_brand(brand_id, **fields)


@app.delete("/brands/{brand_id}")
def remove_brand(brand_id: str) -> dict[str, str]:
    if db.get_brand(brand_id) is None:
        raise HTTPException(404, "brand not found")
    db.delete_brand(brand_id)
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
    """Run to_dart.py then scrape_logos.py against lib/data.dart, the same
    two steps documented in scraper/README.md, now a single button."""
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
    return results
