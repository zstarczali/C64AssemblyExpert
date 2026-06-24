#!/usr/bin/env python3
"""
Codebase64 Wiki Crawler
=======================
Letölti a https://codebase.c64.org wiki összes oldalát raw DokuWiki
formátumban, és .txt fájlokba menti őket.

Futtatás:
  python download_codebase64.py

Kimeneti könyvtár: ./pages/
"""

import sys
import os
import re
import time
import urllib.request
import urllib.error
import urllib.parse
import html
from pathlib import Path

# --- Konfiguráció ---
BASE_URL = "https://codebase.c64.org"
OUTPUT_DIR = Path(__file__).parent / "pages"
DELAY_SECONDS = 0.4   # Udvariassági várakozás kérések között
TIMEOUT = 25

NAMESPACES = [
    'base', 'cia', 'sid', 'vic', 'interrupts',
    '6502_6510_maths', 'tools', 'magazines', 'books',
    'crossdev', 'projects', 'links', 'wiki', 'playground'
]

TOP_LEVEL_PAGES = [
    'start', 'source_conversion', 'history', 'guidelines',
    'quick_howto', 'download_codebase64'
]

PAGE_ID_RE = re.compile(r'doku\.php\?(?:id|idx)=([\w:_\-\.]+)')

# --- Segédfüggvények ---

def fetch(url: str) -> tuple[int, str]:
    """Letölt egy URL-t, visszatér (status_code, text) párral."""
    req = urllib.request.Request(url, headers={
        'User-Agent': 'Mozilla/5.0 (compatible; C64KnowledgeBot/1.0)'
    })
    try:
        with urllib.request.urlopen(req, timeout=TIMEOUT) as resp:
            raw = resp.read()
            encoding = resp.headers.get_content_charset() or 'utf-8'
            return resp.status, raw.decode(encoding, errors='replace')
    except urllib.error.HTTPError as e:
        return e.code, ''
    except Exception as e:
        print(f"  [HIBA] {url}: {e}")
        return 0, ''


def is_html(text: str) -> bool:
    return text.lstrip().startswith('<!DOCTYPE') or text.lstrip().startswith('<html')


def extract_article_from_html(html_text: str) -> str:
    """Kinyeri a cikk szövegét egy HTML oldalból."""
    # <div class="page"> vagy <div id="dokuwiki__content"> belső szöveg
    for pattern in [
        r'<div[^>]+class="[^"]*\bpage\b[^"]*"[^>]*>(.*?)</div>',
        r'<div[^>]+id="dokuwiki__content"[^>]*>(.*?)</div>',
    ]:
        m = re.search(pattern, html_text, re.DOTALL | re.IGNORECASE)
        if m:
            inner = m.group(1)
            # HTML tag-ek eltávolítása
            inner = re.sub(r'<[^>]+>', ' ', inner)
            inner = html.unescape(inner)
            inner = re.sub(r'[ \t]+', ' ', inner)
            inner = re.sub(r'\n\s*\n\s*\n', '\n\n', inner)
            return inner.strip()

    # Ha nem találunk section-t, az összes szöveg tag nélkül
    text = re.sub(r'<script[^>]*>.*?</script>', '', html_text, flags=re.DOTALL)
    text = re.sub(r'<style[^>]*>.*?</style>', '', text, flags=re.DOTALL)
    text = re.sub(r'<[^>]+>', ' ', text)
    text = html.unescape(text)
    text = re.sub(r'[ \t]+', ' ', text)
    text = re.sub(r'\n\s*\n\s*\n', '\n\n', text)
    return text.strip()


def page_id_to_path(page_id: str) -> Path:
    """page_id (pl. 'base:raster_irq') → fájlnév ('base__raster_irq.txt')"""
    safe = page_id.replace(':', '__').replace('/', '__')
    return OUTPUT_DIR / f"{safe}.txt"


def collect_page_ids() -> list[str]:
    """Begyűjti az összes letöltendő oldal ID-ját."""
    all_ids = list(TOP_LEVEL_PAGES)

    for ns in NAMESPACES:
        # Namespace start oldal + index endpoint
        for url in [
            f"{BASE_URL}/doku.php?id={ns}:start",
            f"{BASE_URL}/doku.php?do=index&idx={ns}",
        ]:
            _, text = fetch(url)
            ids = PAGE_ID_RE.findall(text)
            for pid in ids:
                if pid.startswith(ns + ':'):
                    all_ids.append(pid)
            time.sleep(0.2)

        # Namespace saját start lapja is kell
        all_ids.append(f"{ns}:start")

    # Dedup, sorrend megőrzése
    seen = set()
    result = []
    for pid in all_ids:
        if pid not in seen:
            seen.add(pid)
            result.append(pid)
    return result


def download_page(page_id: str) -> bool:
    """
    Letölt egy oldalt és menti a fájlrendszerbe.
    Visszatér True-val ha sikeres.
    """
    out_path = page_id_to_path(page_id)
    if out_path.exists():
        return True  # Már le van töltve

    # 1. Próba: raw DokuWiki export
    url_raw = f"{BASE_URL}/doku.php?do=export_raw&id={page_id}"
    status, text = fetch(url_raw)

    if status == 200 and text and not is_html(text):
        # Raw wiki markup – ez a legjobb
        content = f"# PAGE: {page_id}\n# URL: {url_raw}\n\n{text}"
        out_path.write_text(content, encoding='utf-8')
        return True

    # 2. Fallback: normál HTML oldal, szöveg kinyerése
    url_html = f"{BASE_URL}/doku.php?id={page_id}"
    status2, html_text = fetch(url_html)

    if status2 == 200 and html_text:
        article = extract_article_from_html(html_text)
        if len(article) < 100:
            return False  # Üres/nem-létező oldal
        # DokuWiki "nem létező oldal" üzenet kiszűrése
        if "This topic does not exist yet" in article or "does not exist yet" in article:
            return False
        content = f"# PAGE: {page_id}\n# URL: {url_html}\n# FORMAT: html-extracted\n\n{article}"
        out_path.write_text(content, encoding='utf-8')
        return True

    return False


# --- Főprogram ---

def main():
    OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

    print("=== Codebase64 Wiki Crawler ===")
    print(f"Kimeneti könyvtár: {OUTPUT_DIR}")
    print()

    # 1. lépés: Oldalak összegyűjtése
    print("1. Oldalak listájának összegyűjtése...")
    page_ids = collect_page_ids()
    print(f"   Összesen {len(page_ids)} oldal ID összegyűjtve.")
    print()

    # Lista mentése
    list_path = OUTPUT_DIR.parent / "page_ids.txt"
    list_path.write_text('\n'.join(page_ids), encoding='utf-8')
    print(f"   Lista mentve: {list_path}")
    print()

    # 2. lépés: Letöltés
    print("2. Oldalak letöltése...")
    already_done = sum(1 for pid in page_ids if page_id_to_path(pid).exists())
    total = len(page_ids)
    todo = total - already_done
    print(f"   Már megvan: {already_done}, letöltendő: {todo}")
    print()

    success = already_done
    failed = []

    for i, page_id in enumerate(page_ids):
        if page_id_to_path(page_id).exists():
            continue

        if (i + 1) % 50 == 0 or i < 5:
            print(f"   [{i+1}/{total}] {page_id}")

        ok = download_page(page_id)
        if ok:
            success += 1
        else:
            failed.append(page_id)
            print(f"   [MISS] {page_id}")

        time.sleep(DELAY_SECONDS)

    # 3. lépés: Összesítés
    print()
    print("=== KÉSZ ===")
    print(f"  Sikeres: {success}/{total}")
    print(f"  Sikertelen: {len(failed)}")
    if failed:
        fail_path = OUTPUT_DIR.parent / "failed_pages.txt"
        fail_path.write_text('\n'.join(failed), encoding='utf-8')
        print(f"  Sikertelen lista: {fail_path}")

    # Könyvtár méret
    files = list(OUTPUT_DIR.glob("*.txt"))
    total_size = sum(f.stat().st_size for f in files)
    print(f"  Fájlok: {len(files)} db, összméret: {total_size/1024:.0f} KB")


if __name__ == '__main__':
    sys.stdout.reconfigure(encoding='utf-8', errors='replace')
    main()
