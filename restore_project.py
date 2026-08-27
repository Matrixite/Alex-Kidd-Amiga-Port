#!/usr/bin/env python3
from pathlib import Path
import base64, hashlib, io, lzma, tarfile

ROOT = Path(__file__).resolve().parent
PARTS = ROOT / 'stable-v5.2'
EXPECTED = '1e534df005bd62337f3de8062ec64846d69f3a9a218d54d1c27ef6d49f0a7fed'

# part_02 was re-stored as four verified smaller chunks so its exact
# Base64 text is preserved. The other archive parts remain unchanged.
files = [PARTS / 'part_00.b64', PARTS / 'part_01.b64']
files += [PARTS / f'part_02_{i}.b64' for i in range(4)]
files += [PARTS / f'part_{i:02d}.b64' for i in range(3, 12)]

missing = [str(p) for p in files if not p.exists()]
if missing:
    raise SystemExit('Missing archive pieces: ' + ', '.join(missing))

encoded = b''.join(p.read_bytes().strip() for p in files)
archive = base64.b64decode(encoded)
actual = hashlib.sha256(archive).hexdigest()
if actual != EXPECTED:
    raise SystemExit(f'SHA-256 mismatch: expected {EXPECTED}, got {actual}')

raw_tar = lzma.decompress(archive)
with tarfile.open(fileobj=io.BytesIO(raw_tar), mode='r:') as tf:
    root = ROOT.resolve()
    for member in tf.getmembers():
        target = (ROOT / member.name).resolve()
        if root not in target.parents and target != root:
            raise SystemExit(f'Unsafe path in archive: {member.name}')
    tf.extractall(ROOT)

print('Restored stable v5.2 project successfully.')
print(f'Archive SHA-256: {actual}')
