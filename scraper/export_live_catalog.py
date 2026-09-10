"""Export a rich, balanced live catalog snapshot across all Pakistani brands to website/live_catalog.json."""
from __future__ import annotations

import json
import re
from pathlib import Path
from collections import defaultdict, Counter

ROOT = Path(__file__).resolve().parent.parent
PRODUCTS_PATH = Path(__file__).resolve().parent / "data" / "products.jsonl"
OUT_FILE = ROOT / "website" / "live_catalog.json"

MENS_BRANDS = {
    "amir adnan", "charcoal", "ismail farid", "cambridge", "mohtaram", "uniworth", "diners"
}

WOMENS_BRANDS = {
    "sana safinaz", "beechtree", "generation", "vanya", "mushq", "zeen", "zaaviay", "suffuse"
}

BARE_SKU = re.compile(r"^[A-Za-z]{1,5}[-\s]?\d{2,}[A-Za-z0-9\-\s]*$")


def clean_title(title: str) -> str:
    t = re.sub(r'\s*\|\s*[A-Z0-9\-\/]+$', '', title.strip())
    t = re.sub(r'\s*-\s*[A-Z0-9\-\/]{6,}$', '', t)
    return t.strip()


def determine_gender(rec: dict) -> str:
    b_name = (rec.get("brand_name") or "").lower()
    title = (rec.get("title") or "").lower()
    tags = " ".join(rec.get("tags") or []).lower()
    combined = f"{title} {tags}"

    has_women = bool(re.search(r'\b(women|woman|ladies|lawn|lehenga|gharara|dupatta|kurti|chiffon|frock|pret|bridal|girl|girls|heel|heels|pump|pumps|clutch|tote|handbag|crossbody|peshwas|anarkali|sharara)\b', combined))
    has_men = bool(re.search(r'\b(men|man|mens|gents|boy|boys|kurta|waistcoat|sherwani|latha|boski|chinos?|blazer|prince coat|cufflinks?)\b', combined))

    if b_name in MENS_BRANDS:
        if has_women and not has_men:
            return "Women"
        return "Men"
    
    if b_name in WOMENS_BRANDS:
        if has_men and not has_women:
            return "Men"
        return "Women"

    if has_men and not has_women:
        return "Men"
    if has_women and not has_men:
        return "Women"
    if has_men:
        return "Men"
    return "Women"


def determine_category(rec: dict, gender: str) -> tuple[str, str]:
    title = (rec.get("title") or "").lower()
    ptype = (rec.get("product_type") or "").lower()
    tags = " ".join(rec.get("tags") or []).lower()
    combined = f"{title} {ptype} {tags}"

    if any(k in combined for k in ["waistcoat", "waist coat", "prince coat", "blazer", "coat", "sherwani"]):
        return "waistcoats", "Waistcoats & Coats"
    if any(k in combined for k in ["shalwar kameez", "kameez shalwar", "shalwar suit", "2pc stitched", "2 piece stitched", "3pc stitched", "3 piece stitched"]):
        if gender == "Men":
            return "shalwar-kameez", "Kameez Shalwar"
        return "pret", "Ready to Wear"
    if any(k in combined for k in ["unstitched", "latha", "boski", "fabric", "3 piece unstitched", "3pc unstitched", "2 piece unstitched", "2pc unstitched"]):
        return "unstitched", "Unstitched Fabric"
    if any(k in combined for k in ["lawn"]) and "unstitched" in combined:
        return "unstitched", "Luxury Lawn Unstitched"
    if any(k in combined for k in ["lawn"]):
        return "lawn", "Luxury Lawn"
    if any(k in combined for k in ["kurta", "kurti", "tunic"]):
        return "kurta", "Kurta & Tunics"
    if any(k in combined for k in ["shawl", "dupatta", "stole", "chadar"]):
        return "shawls", "Shawls & Dupattas"
    if any(k in combined for k in ["shoes", "khussa", "heel", "sandal", "clutch", "handbag", "cufflink", "wallet", "belt", "slippers", "slipper"]):
        return "accessories", "Accessories"
    if any(k in combined for k in ["pret", "ready to wear", "shirt", "co-ord", "coord", "frock", "trouser", "culotte"]):
        return "pret", "Ready to Wear"
    
    return "pret", "Ready to Wear"


def determine_occasion(rec: dict) -> str:
    combined = f"{(rec.get('title') or '')} {' '.join(rec.get('tags') or [])}".lower()
    if any(k in combined for k in ["wedding", "bridal", "groom", "barat", "walima", "mehndi", "heirloom"]):
        return "wedding"
    if any(k in combined for k in ["eid", "festive", "celebration", "zari", "gota"]):
        return "eid"
    if any(k in combined for k in ["formal", "luxury", "organza", "silk", "raw silk", "jacquard", "prince coat"]):
        return "formal"
    return "casual"


def determine_badge(rec: dict, gender: str, cat: str, occ: str, tier: str) -> str:
    if tier == "emerging":
        return "Emerging Label"
    if gender == "Men":
        if cat == "kurta":
            return "Men's Kurta"
        if cat == "shalwar-kameez":
            return "Men's Classic"
        if cat == "waistcoats":
            return "Men's Formal"
        return "Men's Eastern"
    if cat == "lawn":
        return "Luxury Lawn"
    if occ in ["wedding", "formal"]:
        return "Festive Couture"
    return "Verified Label"


def get_allowed_brands() -> set[str] | None:
    db_path = Path(__file__).resolve().parent / "data" / "admin.db"
    if not db_path.exists():
        return None
    try:
        import sqlite3
        conn = sqlite3.connect(str(db_path))
        cursor = conn.cursor()
        cursor.execute("SELECT id, name FROM brands WHERE enabled = 1")
        allowed = set()
        for b_id, b_name in cursor.fetchall():
            allowed.add(b_name.lower().strip())
            allowed.add(b_id.lower().strip())
            allowed.add(re.sub(r'[^a-z0-9]', '', b_name.lower()))
            allowed.add(re.sub(r'[^a-z0-9]', '', b_id.lower()))
        conn.close()
        return allowed if allowed else None
    except Exception as e:
        print(f"Warning: could not query brands from {db_path}: {e}")
        return None


def build_catalog_items(per_brand: int = 28) -> list[dict]:
    if not PRODUCTS_PATH.exists():
        print(f"Products file not found at {PRODUCTS_PATH}")
        return []

    allowed_brands = get_allowed_brands()
    by_brand = defaultdict(list)
    with PRODUCTS_PATH.open(encoding="utf-8") as f:
        for line in f:
            if not line.strip():
                continue
            try:
                r = json.loads(line)
            except Exception:
                continue
            
            b_name = r.get("brand_name") or "Unknown"
            if allowed_brands is not None:
                b_clean = re.sub(r'[^a-z0-9]', '', b_name.lower())
                b_low = b_name.lower().strip()
                b_id = (r.get("brand_id") or "").lower().strip()
                if b_low not in allowed_brands and b_id not in allowed_brands and b_clean not in allowed_brands:
                    continue

            title = (r.get("title") or "").strip()
            if len(title) < 5 or BARE_SKU.match(title):
                continue
            images = r.get("images") or []
            price = r.get("price_min") or 0
            if not images or not price or float(price) <= 0:
                continue
            
            img_url = images[0]
            if img_url.startswith("//"):
                img_url = "https:" + img_url
            
            r["_clean_img"] = img_url
            by_brand[b_name].append(r)

    final_catalog = []
    for b_name, items in sorted(by_brand.items()):
        selected = []
        cats_seen = Counter()
        for item in items:
            gender = determine_gender(item)
            cat_key, cat_label = determine_category(item, gender)

            # Cap accessories per brand to 5 so we don't flood clothing catalog
            if cat_key == "accessories" and cats_seen["accessories"] >= 5 and len(selected) < per_brand:
                continue

            occ = determine_occasion(item)
            tier = item.get("brand_tier") or "established"
            badge = determine_badge(item, gender, cat_key, occ, tier)
            
            tags = [gender.lower(), cat_key.lower(), occ.lower(), b_name.lower()]
            if cat_key == "lawn":
                tags.extend(["lawn", "unstitched", "summer"])
            if cat_key == "unstitched":
                tags.extend(["unstitched", "fabric"])
            if cat_key == "pret":
                tags.extend(["pret", "ready-to-wear"])
            if cat_key in ["kurta", "shalwar-kameez"]:
                tags.extend(["kurta", "shalwar-kameez", "traditional"])
            if cat_key == "waistcoats":
                tags.extend(["waistcoats", "formal"])
            if cat_key == "shawls":
                tags.extend(["shawls", "dupatta"])
            if occ in ["eid", "wedding", "formal"]:
                tags.extend(["eid", "wedding", "formal", "festive"])
            if tier == "emerging":
                tags.extend(["emerging", "designer"])
            else:
                tags.extend(["verified", "popular"])

            tags = list(dict.fromkeys(tags))
            
            price_val = int(round(float(item.get("price_min") or 0)))
            orig_val = int(round(float(item.get("price_max") or price_val)))
            
            clean_t = clean_title(item.get("title") or "")
            selected.append({
                "id": item.get("product_uid") or f"{item.get('brand_id')}:{item.get('id')}",
                "brand": b_name,
                "title": clean_t,
                "price": price_val,
                "original_price": orig_val,
                "gender": gender.lower(),
                "category": cat_key,
                "category_label": cat_label,
                "occasion": occ,
                "tags": tags,
                "image": item["_clean_img"],
                "url": item.get("url") or "#",
                "badge": badge,
                "brand_tier": tier,
                "in_stock": item.get("in_stock", True)
            })
            cats_seen[cat_key] += 1
            if len(selected) >= per_brand:
                break
        
        final_catalog.extend(selected)

    return final_catalog


def main():
    print(f"Reading from {PRODUCTS_PATH}...")
    catalog = build_catalog_items(per_brand=28)
    print(f"Built {len(catalog)} products across {len(set(x['brand'] for x in catalog))} brands.")
    
    OUT_FILE.parent.mkdir(parents=True, exist_ok=True)
    with OUT_FILE.open("w", encoding="utf-8") as f:
        json.dump(catalog, f, indent=2, ensure_ascii=False)
    
    print(f"Successfully exported {len(catalog)} items to {OUT_FILE}")
    
    brands_count = Counter(x["brand"] for x in catalog)
    gender_count = Counter(x["gender"] for x in catalog)
    cat_count = Counter(x["category"] for x in catalog)
    print(f"Brands: {brands_count}")
    print(f"Genders: {gender_count}")
    print(f"Categories: {cat_count}")


if __name__ == "__main__":
    main()
