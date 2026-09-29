#!/usr/bin/env python3
"""Step 1: Extract chunks (one per page) from raw books JSON."""
import json
import sys
from pathlib import Path

import yaml
from tqdm import tqdm


def load_config(path="/work/configs/default.yaml"):
    with open(path) as f:
        return yaml.safe_load(f)


def norm(s):
    if s is None:
        return ""
    return str(s).strip()


def make_chunk_text(page):
    """Reproduce the mesbahv2 chunk_text format."""
    meta = "Metadata: " + "\n".join([
        f"book_name:{norm(page.get('title'))}",
        f"book_id:{norm(page.get('dap_code'))}",
        f"page_number:{page.get('page_number') or 0}",
    ])
    content = norm(page.get("paragraph_text"))
    return f"{meta}\n-----\nContent: {content}"


def main():
    cfg = load_config()
    run = cfg["run"]
    chunking = cfg["chunking"]

    input_json = Path(run["input_json"])
    out_dir = Path(run["output_dir"]) / run["name"]
    out_dir.mkdir(parents=True, exist_ok=True)
    out_file = out_dir / "chunks.jsonl"

    min_chars = chunking.get("min_text_chars", 20)

    print(f"[01] Loading {input_json} ...", flush=True)
    with open(input_json, "r", encoding="utf-8") as f:
        books = json.load(f)
    print(f"[01] Loaded {len(books)} books.", flush=True)

    total = 0
    skipped = 0

    with open(out_file, "w", encoding="utf-8") as fo:
        for book in tqdm(books, desc="books"):
            dap_code = norm(book.get("dap_code"))
            pages = book.get("pages") or []

            for idx, page in enumerate(pages):
                text = norm(page.get("paragraph_text"))
                if len(text) < min_chars:
                    skipped += 1
                    continue

                chunk = {
                    "book_id": dap_code,
                    "book_name": norm(page.get("title")),
                    "page_number": page.get("page_number") or 0,
                    "chunk_id": idx,
                    "chunk_text": make_chunk_text(page),
                    "link": f"book://{dap_code}#p{page.get('page_number')}",
                    "source_id": page.get("_id"),
                    "language": norm(page.get("language")),
                    "words_count": page.get("words_count") or 0,
                }
                fo.write(json.dumps(chunk, ensure_ascii=False) + "\n")
                total += 1

    print(f"[01] DONE. chunks={total} skipped_short={skipped}")
    print(f"[01] Output: {out_file}")


if __name__ == "__main__":
    main()
