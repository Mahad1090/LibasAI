"""SQLite-backed brand registry + job history for the admin server.

Replaces `brands.yaml` as the source of truth: brands are added/edited through
the admin app (or the API directly) instead of hand-editing YAML. See
`migrate_yaml.py` for the one-off import of the old file into this DB.
"""
from __future__ import annotations

import sqlite3
import time
from contextlib import contextmanager
from pathlib import Path
from typing import Any, Iterator

DB_PATH = Path(__file__).resolve().parent.parent / "data" / "admin.db"

SCHEMA = """
CREATE TABLE IF NOT EXISTS brands (
    id            TEXT PRIMARY KEY,
    name          TEXT NOT NULL,
    base_url      TEXT NOT NULL,
    type          TEXT NOT NULL DEFAULT 'unknown',   -- shopify | woocommerce | generic | unknown
    tier          TEXT NOT NULL DEFAULT 'emerging',  -- established | emerging
    currency      TEXT NOT NULL DEFAULT 'PKR',
    enabled       INTEGER NOT NULL DEFAULT 1,
    detected_at   TEXT,
    detect_note   TEXT,
    created_at    TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS jobs (
    id              INTEGER PRIMARY KEY AUTOINCREMENT,
    brand_id        TEXT,                 -- NULL = "all enabled brands" run
    status          TEXT NOT NULL DEFAULT 'running',  -- running | success | failed
    started_at      TEXT NOT NULL,
    finished_at     TEXT,
    products_count  INTEGER NOT NULL DEFAULT 0,
    log             TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS tailors (
    id                TEXT PRIMARY KEY,
    name              TEXT NOT NULL,
    city              TEXT NOT NULL,
    location          TEXT NOT NULL,
    experience_years  INTEGER NOT NULL DEFAULT 10,
    rating            REAL NOT NULL DEFAULT 4.8,
    review_count      INTEGER NOT NULL DEFAULT 50,
    turnaround_days   TEXT NOT NULL DEFAULT '3-5',
    starting_price    INTEGER NOT NULL DEFAULT 2500,
    status            TEXT NOT NULL DEFAULT 'accepting',  -- accepting | at_capacity | paused
    specialties_json  TEXT NOT NULL DEFAULT '[]',
    is_verified       INTEGER NOT NULL DEFAULT 1,
    rates_json        TEXT NOT NULL DEFAULT '{}'
);

CREATE TABLE IF NOT EXISTS orders (
    id                 TEXT PRIMARY KEY,
    customer_name      TEXT NOT NULL,
    customer_phone     TEXT NOT NULL,
    tailor_id          TEXT NOT NULL,
    tailor_name        TEXT NOT NULL,
    outfit_title       TEXT NOT NULL,
    gender             TEXT NOT NULL DEFAULT 'Women',
    fabric_source      TEXT NOT NULL,
    measurement_notes  TEXT NOT NULL DEFAULT '',
    delivery_address   TEXT NOT NULL,
    order_date         TEXT NOT NULL,
    estimated_delivery TEXT NOT NULL,
    price              INTEGER NOT NULL DEFAULT 3500,
    stage_index        INTEGER NOT NULL DEFAULT 0,
    status             TEXT NOT NULL DEFAULT 'Fabric Received & Verified',
    tracking_code      TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS taxonomy (
    id         TEXT PRIMARY KEY,
    alias      TEXT NOT NULL,
    canonical  TEXT NOT NULL,
    category   TEXT NOT NULL,
    weight     REAL NOT NULL DEFAULT 1.0
);

CREATE TABLE IF NOT EXISTS brand_clicks (
    brand_name TEXT PRIMARY KEY,
    clicks     INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS search_queries (
    id         INTEGER PRIMARY KEY AUTOINCREMENT,
    query      TEXT NOT NULL,
    count      INTEGER NOT NULL DEFAULT 1,
    category   TEXT NOT NULL DEFAULT 'General'
);
"""


def _row_to_brand(row: sqlite3.Row) -> dict[str, Any]:
    d = dict(row)
    d["enabled"] = bool(d["enabled"])
    return d


@contextmanager
def get_conn() -> Iterator[sqlite3.Connection]:
    DB_PATH.parent.mkdir(parents=True, exist_ok=True)
    conn = sqlite3.connect(DB_PATH)
    conn.row_factory = sqlite3.Row
    conn.execute("PRAGMA foreign_keys = ON")
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def init_db() -> None:
    import json

    with get_conn() as conn:
        conn.executescript(SCHEMA)

        # Seed tailors if empty
        if conn.execute("SELECT count(*) FROM tailors").fetchone()[0] == 0:
            tailors_seed = [
                (
                    "tailor_rafiq", "Master Rafiq & Sons", "Lahore", "Anarkali Bazaar, Old Lahore",
                    28, 4.9, 184, "3-4", 2800, "accepting",
                    json.dumps(["Men's Kurta & Shalwar", "Boski & Raw Silk", "Waistcoats"]), 1,
                    json.dumps({
                        "Standard Kurta Shalwar": 2800,
                        "Raw Silk / Boski Suit": 3800,
                        "Embroidered Waistcoat": 4500,
                        "Prince Coat / Sherwani": 14000,
                    })
                ),
                (
                    "tailor_noor", "Noor Bridal Atelier", "Karachi", "Tariq Road, PECHS Block 2",
                    22, 4.9, 215, "4-6", 3200, "accepting",
                    json.dumps(["Women's 3-Piece Lawn", "Bridal & Formal Pret", "Lehengas & Ghararas"]), 1,
                    json.dumps({
                        "Simple Lawn 3-Piece": 3200,
                        "Embroidered Luxury Lawn": 4200,
                        "Raw Silk Formal Suit": 6500,
                        "Heavy Bridal Lehenga": 28000,
                    })
                ),
                (
                    "tailor_aslam", "Ustaad Aslam Master Tailors", "Islamabad", "F-7 Markaz, Jinnah Super Market",
                    31, 4.8, 142, "2-3", 3500, "accepting",
                    json.dumps(["Executive Kurta Shalwar", "Prince Coats", "Embroidery Matching"]), 1,
                    json.dumps({
                        "Executive Kurta Shalwar": 3500,
                        "Latha / Karandi Suit": 4200,
                        "Bespoke Prince Coat": 16000,
                    })
                ),
                (
                    "tailor_gulberg", "Gulberg Express Stitching", "Lahore", "Main Boulevard, Gulberg III",
                    16, 4.7, 96, "24-48h", 3000, "accepting",
                    json.dumps(["Express 48h Delivery", "Women's Pret", "Designer Cut Duplication"]), 1,
                    json.dumps({
                        "Express 24h Kurta": 3000,
                        "3-Piece Suit Stitching": 3800,
                        "Designer Pattern Copy": 5000,
                    })
                ),
                (
                    "tailor_saddar", "Saddar Heritage Darzi", "Rawalpindi", "Bank Road, Saddar Cantt",
                    35, 4.8, 168, "4-5", 2600, "at_capacity",
                    json.dumps(["Pure Cotton Latha", "Traditional Ban Collar", "Shalwar Ghera Cuts"]), 1,
                    json.dumps({
                        "Heritage Kurta Shalwar": 2600,
                        "Double Pocket Kurta": 3000,
                        "Khaddar Winter Suit": 3200,
                    })
                ),
                (
                    "tailor_zahra", "Al-Zahra Haute Couture", "Faisalabad", "D-Ground Commercial Area",
                    19, 4.9, 128, "3-5", 2900, "accepting",
                    json.dumps(["Chiffon & Organza Dupattas", "A-Line Kurtis", "Pearl Lace Finishing"]), 1,
                    json.dumps({
                        "Lawn Suit with Lace Detailing": 2900,
                        "Organza Formal Kurti": 3600,
                        "Hand Embroidered Ensemble": 7500,
                    })
                ),
            ]
            conn.executemany(
                "INSERT INTO tailors (id, name, city, location, experience_years, rating, review_count, "
                "turnaround_days, starting_price, status, specialties_json, is_verified, rates_json) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                tailors_seed,
            )

        # Seed orders if empty
        if conn.execute("SELECT count(*) FROM orders").fetchone()[0] == 0:
            orders_seed = [
                (
                    "REQ-8492", "Hamza Tariq", "+92 321 8492019", "tailor_rafiq", "Master Rafiq & Sons",
                    "Festive Raw Silk Kurta Shalwar", "Men", "J. Junaid Jamshed Pure Latha",
                    "Reference suit picked up from Gulberg III", "House 42, Street 8, Gulberg III, Lahore",
                    "Sep 4, 2026", "Sep 10, 2026", 3500, 2, "Hand & Machine Stitching", "LBS-LHR-9823"
                ),
                (
                    "REQ-7911", "Zainab Malik", "+92 301 9283741", "tailor_gulberg", "Gulberg Express Stitching",
                    "3-Piece Embroidered Lawn Suit with Organza Dupatta", "Women", "Sana Safinaz Luxury Lawn 2026",
                    "Standard Medium + 2 inches shirt length", "Apartment 4B, Mall 1, Main Boulevard, Lahore",
                    "Sep 6, 2026", "Sep 11, 2026", 4200, 1, "Cutting & Marking", "LBS-LHR-7741"
                ),
                (
                    "REQ-9104", "Bilal Farooq", "+92 333 4920182", "tailor_aslam", "Ustaad Aslam Master Tailors",
                    "Embroidered Ban Collar Waistcoat", "Men", "Amir Adnan Raw Silk Jacquard",
                    'Chest 40", Shoulder 18", Length 28"', "House 19, Street 44, F-8/1, Islamabad",
                    "Sep 7, 2026", "Sep 13, 2026", 4500, 0, "Fabric Received & Verified", "LBS-ISB-2041"
                ),
            ]
            conn.executemany(
                "INSERT INTO orders (id, customer_name, customer_phone, tailor_id, tailor_name, "
                "outfit_title, gender, fabric_source, measurement_notes, delivery_address, "
                "order_date, estimated_delivery, price, stage_index, status, tracking_code) "
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
                orders_seed,
            )

        # Seed taxonomy if empty
        if conn.execute("SELECT count(*) FROM taxonomy").fetchone()[0] == 0:
            tax_seed = [
                ("t1", "Latha", "Pure White Cotton Fabric", "Men Fabric", 1.0),
                ("t2", "Ban Collar", "Mandarin / Nehru Collar", "Collar Cut", 0.95),
                ("t3", "Boski", "Pure Spun Chinese Silk Fabric", "Luxury Fabric", 0.9),
                ("t4", "Organza", "Sheer Plain Weave Silk/Poly", "Dupatta & Trims", 0.9),
                ("t5", "Ghera", "Flared Hemline Circumference", "Silhouettes", 0.85),
                ("t6", "Jamawar", "Brocade Jacquard Fabric with Metallic Weft", "Weave", 0.85),
            ]
            conn.executemany(
                "INSERT INTO taxonomy (id, alias, canonical, category, weight) VALUES (?, ?, ?, ?, ?)",
                tax_seed,
            )

        # Seed brand_clicks if empty
        if conn.execute("SELECT count(*) FROM brand_clicks").fetchone()[0] == 0:
            clicks_seed = [
                ("Sana Safinaz", 342),
                ("J. Junaid Jamshed", 288),
                ("Gul Ahmed", 210),
                ("Vanya", 195),
                ("Beechtree", 164),
                ("Amir Adnan", 130),
                ("Charcoal", 91),
            ]
            conn.executemany(
                "INSERT INTO brand_clicks (brand_name, clicks) VALUES (?, ?)",
                clicks_seed,
            )

        # Seed search_queries if empty
        if conn.execute("SELECT count(*) FROM search_queries").fetchone()[0] == 0:
            queries_seed = [
                ("Men black kurta under 5k", 412, "Men"),
                ("Festive raw silk 3-piece", 328, "Women"),
                ("Lawn with organza dupatta", 264, "Women"),
                ("Embroidered waistcoat", 198, "Men"),
                ("Emerging designer wedding pret", 145, "Luxury"),
            ]
            conn.executemany(
                "INSERT INTO search_queries (query, count, category) VALUES (?, ?, ?)",
                queries_seed,
            )


def now() -> str:
    return time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime())


# ---- brands ----------------------------------------------------------------

def list_brands(*, enabled_only: bool = False) -> list[dict[str, Any]]:
    with get_conn() as conn:
        q = "SELECT * FROM brands"
        if enabled_only:
            q += " WHERE enabled = 1"
        q += " ORDER BY created_at"
        return [_row_to_brand(r) for r in conn.execute(q)]


def get_brand(brand_id: str) -> dict[str, Any] | None:
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM brands WHERE id = ?", (brand_id,)).fetchone()
        return _row_to_brand(row) if row else None


def _slugify(name: str) -> str:
    import re

    slug = re.sub(r"[^a-z0-9]+", "_", name.strip().lower()).strip("_")
    return slug or "brand"


def insert_brand(
    *,
    name: str,
    base_url: str,
    type_: str = "unknown",
    tier: str = "emerging",
    currency: str = "PKR",
    enabled: bool = True,
    brand_id: str | None = None,
) -> dict[str, Any]:
    with get_conn() as conn:
        bid = brand_id or _slugify(name)
        base = bid
        i = 2
        while conn.execute("SELECT 1 FROM brands WHERE id = ?", (bid,)).fetchone():
            bid = f"{base}_{i}"
            i += 1
        conn.execute(
            "INSERT INTO brands (id, name, base_url, type, tier, currency, enabled, created_at) "
            "VALUES (?, ?, ?, ?, ?, ?, ?, ?)",
            (bid, name, base_url.rstrip("/"), type_, tier, currency, int(enabled), now()),
        )
    return get_brand(bid)  # type: ignore[return-value]


def update_brand(brand_id: str, **fields: Any) -> dict[str, Any] | None:
    if not fields:
        return get_brand(brand_id)
    allowed = {"name", "base_url", "type", "tier", "currency", "enabled", "detected_at", "detect_note"}
    sets, vals = [], []
    for k, v in fields.items():
        if k not in allowed:
            continue
        if k == "enabled":
            v = int(bool(v))
        sets.append(f"{k} = ?")
        vals.append(v)
    if not sets:
        return get_brand(brand_id)
    vals.append(brand_id)
    with get_conn() as conn:
        conn.execute(f"UPDATE brands SET {', '.join(sets)} WHERE id = ?", vals)
    return get_brand(brand_id)


def delete_brand(brand_id: str) -> None:
    with get_conn() as conn:
        conn.execute("DELETE FROM brands WHERE id = ?", (brand_id,))


# ---- jobs -------------------------------------------------------------------

def create_job(brand_id: str | None) -> int:
    with get_conn() as conn:
        cur = conn.execute(
            "INSERT INTO jobs (brand_id, status, started_at) VALUES (?, 'running', ?)",
            (brand_id, now()),
        )
        return cur.lastrowid


def finish_job(job_id: int, *, status: str, products_count: int, log: str) -> None:
    with get_conn() as conn:
        conn.execute(
            "UPDATE jobs SET status = ?, finished_at = ?, products_count = ?, log = ? WHERE id = ?",
            (status, now(), products_count, log, job_id),
        )


def append_job_log(job_id: int, line: str) -> None:
    with get_conn() as conn:
        conn.execute(
            "UPDATE jobs SET log = log || ? WHERE id = ?", (line.rstrip("\n") + "\n", job_id)
        )


def get_job(job_id: int) -> dict[str, Any] | None:
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM jobs WHERE id = ?", (job_id,)).fetchone()
        return dict(row) if row else None


def list_jobs(limit: int = 50) -> list[dict[str, Any]]:
    with get_conn() as conn:
        rows = conn.execute(
            "SELECT * FROM jobs ORDER BY id DESC LIMIT ?", (limit,)
        ).fetchall()
        return [dict(r) for r in rows]


# ---- tailors ----------------------------------------------------------------

def _row_to_tailor(row: sqlite3.Row) -> dict[str, Any]:
    import json
    d = dict(row)
    d["is_verified"] = bool(d["is_verified"])
    try:
        d["specialties"] = json.loads(d.pop("specialties_json", "[]"))
    except Exception:
        d["specialties"] = []
    try:
        d["rates"] = json.loads(d.pop("rates_json", "{}"))
    except Exception:
        d["rates"] = {}
    return d


def list_tailors() -> list[dict[str, Any]]:
    with get_conn() as conn:
        rows = conn.execute("SELECT * FROM tailors ORDER BY rating DESC").fetchall()
        return [_row_to_tailor(r) for r in rows]


def get_tailor(tailor_id: str) -> dict[str, Any] | None:
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM tailors WHERE id = ?", (tailor_id,)).fetchone()
        return _row_to_tailor(row) if row else None


def update_tailor(tailor_id: str, **fields: Any) -> dict[str, Any] | None:
    import json
    if not fields:
        return get_tailor(tailor_id)
    allowed = {
        "name", "city", "location", "experience_years", "rating",
        "review_count", "turnaround_days", "starting_price", "status",
        "specialties", "is_verified", "rates"
    }
    sets, vals = [], []
    for k, v in fields.items():
        if k not in allowed:
            continue
        if k == "specialties":
            sets.append("specialties_json = ?")
            vals.append(json.dumps(v))
        elif k == "rates":
            sets.append("rates_json = ?")
            vals.append(json.dumps(v))
        elif k == "is_verified":
            sets.append("is_verified = ?")
            vals.append(int(bool(v)))
        else:
            sets.append(f"{k} = ?")
            vals.append(v)
    if not sets:
        return get_tailor(tailor_id)
    vals.append(tailor_id)
    with get_conn() as conn:
        conn.execute(f"UPDATE tailors SET {', '.join(sets)} WHERE id = ?", vals)
    return get_tailor(tailor_id)


# ---- orders -----------------------------------------------------------------

def _row_to_order(row: sqlite3.Row) -> dict[str, Any]:
    return dict(row)


def list_orders() -> list[dict[str, Any]]:
    with get_conn() as conn:
        rows = conn.execute("SELECT * FROM orders ORDER BY id DESC").fetchall()
        return [_row_to_order(r) for r in rows]


def get_order(order_id: str) -> dict[str, Any] | None:
    with get_conn() as conn:
        row = conn.execute("SELECT * FROM orders WHERE id = ?", (order_id,)).fetchone()
        return _row_to_order(row) if row else None


def update_order(order_id: str, **fields: Any) -> dict[str, Any] | None:
    if not fields:
        return get_order(order_id)
    allowed = {
        "customer_name", "customer_phone", "tailor_id", "tailor_name",
        "outfit_title", "gender", "fabric_source", "measurement_notes",
        "delivery_address", "order_date", "estimated_delivery", "price",
        "stage_index", "status", "tracking_code"
    }
    sets, vals = [], []
    for k, v in fields.items():
        if k in allowed:
            sets.append(f"{k} = ?")
            vals.append(v)
    if not sets:
        return get_order(order_id)
    vals.append(order_id)
    with get_conn() as conn:
        conn.execute(f"UPDATE orders SET {', '.join(sets)} WHERE id = ?", vals)
    return get_order(order_id)


# ---- taxonomy ---------------------------------------------------------------

def list_taxonomy() -> list[dict[str, Any]]:
    with get_conn() as conn:
        rows = conn.execute("SELECT * FROM taxonomy ORDER BY weight DESC").fetchall()
        return [dict(r) for r in rows]


def insert_taxonomy(*, id_: str, alias: str, canonical: str, category: str, weight: float = 1.0) -> dict[str, Any]:
    with get_conn() as conn:
        conn.execute(
            "INSERT OR REPLACE INTO taxonomy (id, alias, canonical, category, weight) VALUES (?, ?, ?, ?, ?)",
            (id_, alias, canonical, category, weight),
        )
    return {"id": id_, "alias": alias, "canonical": canonical, "category": category, "weight": weight}


def delete_taxonomy(term_id: str) -> None:
    with get_conn() as conn:
        conn.execute("DELETE FROM taxonomy WHERE id = ?", (term_id,))


# ---- analytics: brand clicks & search queries -------------------------------

def get_brand_clicks() -> dict[str, int]:
    with get_conn() as conn:
        rows = conn.execute("SELECT brand_name, clicks FROM brand_clicks ORDER BY clicks DESC").fetchall()
        return {r["brand_name"]: r["clicks"] for r in rows}


def record_brand_click(brand_name: str) -> None:
    with get_conn() as conn:
        conn.execute(
            "INSERT INTO brand_clicks (brand_name, clicks) VALUES (?, 1) "
            "ON CONFLICT(brand_name) DO UPDATE SET clicks = clicks + 1",
            (brand_name,),
        )


def get_search_queries(limit: int = 10) -> list[dict[str, Any]]:
    with get_conn() as conn:
        rows = conn.execute("SELECT query, count, category FROM search_queries ORDER BY count DESC LIMIT ?", (limit,)).fetchall()
        return [dict(r) for r in rows]


def log_search_query(query: str, category: str = "General") -> None:
    with get_conn() as conn:
        row = conn.execute("SELECT id FROM search_queries WHERE query = ?", (query,)).fetchone()
        if row:
            conn.execute("UPDATE search_queries SET count = count + 1 WHERE id = ?", (row["id"],))
        else:
            conn.execute("INSERT INTO search_queries (query, count, category) VALUES (?, 1, ?)", (query, category))

