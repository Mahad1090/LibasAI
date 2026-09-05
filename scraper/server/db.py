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
    with get_conn() as conn:
        conn.executescript(SCHEMA)


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
