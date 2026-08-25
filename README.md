# Alex Kidd Amiga Port

Work-in-progress native Amiga 1200 port of **Alex Kidd in the Enchanted Castle**.

Ported by **MATRIX — 2026**.

## Current state

The latest test build produced during development is **Phase 8A**. The recoverable source snapshot currently committed here is the **Phase 7X WHDLoad slave source**.

The port is unfinished. Known areas still needing work include:

- gameplay accuracy
- screen flashing while scrolling
- car movement and collision behaviour
- kick and crawl animation frames
- interactive objects and sprites
- authentic health and death sequences

## Requirements

- Amiga 1200 / AGA
- Motorola 68020
- WHDLoad development includes
- vasm with Motorola syntax support
- a legally obtained copy of the original game data

## Building the WHDLoad slave

```sh
vasmm68k_mot -m68020 -Fhunkexe -kick1hunks -nosym \
  -I<path-to-WHDLoad-Include> \
  -o AlexKidd.slave src/AlexKiddHD.asm
```

The Phase 7X source expects the native payload in `Disk.1` and loads it from ADF offset `$400`.

## Repository contents

- `src/AlexKiddHD.asm` — Phase 7X WHDLoad slave source

## Legal note

This repository contains port code only. It does not include the original Sega/Mega Drive ROM, extracted proprietary game assets, or redistributable game binaries.
