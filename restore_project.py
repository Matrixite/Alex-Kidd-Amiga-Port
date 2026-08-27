#!/usr/bin/env python3
from pathlib import Path
import base64
import hashlib
import io
import lzma
import tarfile

ROOT = Path(__file__).resolve().parent
PARTS = ROOT / "stable-v5.2"
EXPECTED = "1e534df005bd62337f3de8062ec64846d69f3a9a218d54d1c27ef6d49f0a7fed"

encoded = b"".join(p.read_bytes().strip() for p in sorted(PARTS.glob("part_*.b64")))
archive = base64.b64decode(encoded)
actual = hashlib.sha256(archive).hexdigest()
if actual != EXPECTED:
    raise SystemExit(f"Archive checksum mismatch: {actual} != {EXPECTED}")

with tarfile.open(fileobj=io.BytesIO(archive), mode="r:xz") as tf:
    tf.extractall(ROOT)

print("Stable Alex Kidd Amiga Port v5.2 project restored successfully.")
