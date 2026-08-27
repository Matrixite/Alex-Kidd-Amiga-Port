# Alex Kidd in the Enchanted Castle — Amiga Port

An in-progress **Amiga 1200 / AGA** port of *Alex Kidd in the Enchanted Castle*, rebuilt in **Scorpion Engine** from analysis of the original Mega Drive game.

> **Current stable baseline: v5.2**  
> The later v5.3.x building-wall parallax experiments were deliberately rolled back because they disturbed previously-correct graphics and gameplay.

## Stable project download / restoration

The full stable v5.2 Scorpion project is stored in this repository as a verified split archive under `stable-v5.2/`. This avoids including the original Mega Drive ROM and preserves the complete project snapshot, including the binary graphics assets.

To reconstruct the project files in a clone, run:

```bash
python3 restore_project.py
```

The script joins the 12 archive parts, verifies SHA-256 `1e534df005bd62337f3de8062ec64846d69f3a9a218d54d1c27ef6d49f0a7fed`, and extracts the stable project into the repository directory. The archive contains 199 project files. No full Mega Drive ROM is included.

## Project status

The project is not a finished full-game port yet. The current focus is **Rookietown / Stage 1**, Alex's movement and animation, collision, enemies, chests, camera behaviour, title presentation and ROM-derived graphics.

### Current stable work

- Amiga 1200 / AGA Scorpion project opens from `project.sproject` after restoring the project archive.
- Rookietown uses the corrected **96 × 28** ROM-derived level layout.
- Stage 1 map streams use the corrected Mega Drive map decompression logic.
- 16×16 metatiles use the corrected quadrant order **TL, TR, BL, BR**.
- Stage 1 tile/GID ordering was rebuilt so buildings, trees and asymmetric graphics join correctly.
- AGA palette/transparency work has been added for more faithful ROM colours.
- Alex can move both directions and the camera supports **backtracking**.
- ROM-derived standing, walking, jumping, crawling and punching work is present.
- Standing and crawling punch handling are separated so jumping does not incorrectly fall into crawl behaviour.
- ROM-derived angel/death animation work is present.
- Enemy collision/death handling and punch-to-defeat logic have been added.
- Rookietown enemy placement has been reconstructed from ROM object data and corrected for coordinate/origin issues.
- Chests are interactive: Alex can pass through their sides while standing on their tops as one-way platforms.
- ROM-derived chest reward handling has been added.
- Grey-wall collision prevents Alex walking through the walls.
- Main floor collision uses a top-surface/platform model rather than one large solid rectangle.
- Lowered/dipped Rookietown floor sections are walkable: Alex can drop into them and stand on the lower floor.
- Camera framing/floor visibility fixes are included.
- ROM title/intro extraction and title flicker/parser fixes are included.

## Progress history

| Version / phase | Progress |
|---|---|
| v0.9 | Initial Rookietown object coordinate correction. |
| v1.0 | Further object-coordinate alignment fixes. |
| v1.1 | Corrected ROM object origins / spawn placement. |
| v1.4 | Amiga 1200 AGA compiler compatibility fixes. |
| v1.5 | Additional AGA compiler/build fixes. |
| v1.6 | Default icon / launch handling fix. |
| v1.9 | Exact-runtime ROM palette work. |
| v2.0 | AGA visual transparency fixes. |
| v2.1 | Rookietown ROM palette correction. |
| v2.2 | Initial Rookietown tile-order correction. |
| v2.3 | ROM death-animation work. |
| v2.4 | Enemy collision and player-death behaviour. |
| v2.5 | ROM angel death sequence. |
| v2.6 | Crawl-control fixes. |
| v2.7 | Crawl attack-direction/compiler fix. |
| v2.8–v3.0 | Camera floor framing, parser and floor-graphics corrections. |
| v3.1 | ROM floor collision pass. |
| v3.2 | Rookietown collision reconstruction. |
| v3.3 | Proper ROM crawl behaviour. |
| v3.4 | Jump and chest collision fixes. |
| v3.5 | One-way chest platform behaviour. |
| v3.6 | Original floor graphics restored. |
| v3.7 | Grey-wall collision. |
| v3.8 | Exact ROM punch work. |
| v3.9 | Leftward backtracking / camera behaviour. |
| v4.0 | ROM title intro integration. |
| v4.1 | Title-screen flicker fixes. |
| v4.2 | Startup parser fix. |
| v4.3 | Title animation/static-title stability work. |
| v4.4 | ROM enemy punch/kill behaviour. |
| v4.5 / v4.5.1 | ROM chest rewards and reward corrections. |
| v4.6 | Rookietown layout restoration attempt. |
| v4.7 | Correct ROM map decoder and full 96×28 layout rebuild. |
| v4.8 | Graphic tile-order investigation. |
| v4.9 | Scorpion tileset import/GID correction. |
| v5.0 | Corrected building/tree metatile assembly (**TL, TR, BL, BR**). |
| v5.1 | Floor collision changed to top-surface/platform behaviour. |
| **v5.2** | **Current stable state:** lowered floor dips are open and walkable with lower standable surfaces. |
| v5.3.x | Experimental building-wall parallax work; **reverted and excluded from the stable baseline**. |

## Important Rookietown technical notes

### ROM map decoding

Rookietown's two compressed map streams were decoded using the behaviour of the original 68000 routine rather than the earlier guessed decoder. The logical map dimensions are **96 metatiles × 28 metatiles**, or **2,688 entries per map plane**.

### Metatile order

A major visual problem was caused by assembling each 16×16 metatile with the wrong 8×8 quadrant order. The stable renderer uses:

```text
Top-left     Top-right
Bottom-left  Bottom-right
```

or **TL, TR, BL, BR**. This is particularly visible on palm trees, roofs, doors, windows and building edges.

### Collision

- normal street surface: top-only/platform-style collision
- lowered street sections: open above, with a lower walkable surface
- grey walls/boundaries: solid where required
- chests: passable from the side, standable from above

## Building / running

1. Clone or download this repository.
2. Run `python3 restore_project.py` to restore the complete stable v5.2 project files.
3. Install a compatible recent version of **Scorpion Engine / Scorpion Editor 2026.x**.
4. Open `project.sproject`.
5. Select the **Amiga AGA** target and build/test Rookietown.

## Not finished yet

- building-wall parallax effect — the v5.3.x experiments were reverted
- remaining stages beyond Rookietown
- complete enemy/boss/game-event behaviour
- complete audio/music reproduction
- final full-game polish
- final WHDLoad/release packaging

Future work should preserve the v5.2 baseline and make isolated changes so working movement, graphics, collision and camera behaviour do not regress.

## ROM / copyright note

The repository does **not** include a complete Mega Drive ROM image. Development/reference data was produced while analysing a user-supplied copy of the original game. You should own the original game/ROM used for further extraction or verification.

This is a fan-made preservation/porting project and is not affiliated with or endorsed by SEGA.
