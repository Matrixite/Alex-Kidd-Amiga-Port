# Alex Kidd in the Enchanted Castle — Amiga Port

This is my work-in-progress port of **Alex Kidd in the Enchanted Castle** to the **Amiga 1200 / AGA**, using **Scorpion Engine**.

The aim is to get the Amiga version looking and playing as close to the original Mega Drive game as I can, while rebuilding the game piece by piece rather than just approximating it.

At the moment most of the work has been focused on **Rookietown / Stage 1**, Alex himself, collision, enemies, chests, camera movement and getting the original graphics into Scorpion correctly.

> **Current stable version: v5.2**
>
> I tried a few different ways of adding the building-wall parallax after this, but they caused other parts of the level to break. I rolled those experiments back rather than leave the project in a worse state, so v5.2 is the clean baseline going forward.

## Getting the project

The complete stable v5.2 Scorpion project is stored in `stable-v5.2/` as a split archive.

I did it this way so I could keep the complete project snapshot, including its binary graphics files, without putting the original Mega Drive ROM in the repository.

After cloning the repo, run:

```bash
python3 restore_project.py
```

That will join the 12 archive parts, check the SHA-256 hash and extract the project into the repository folder.

The restored snapshot contains **199 project files**.

The expected SHA-256 is:

```text
1e534df005bd62337f3de8062ec64846d69f3a9a218d54d1c27ef6d49f0a7fed
```

## Where the port is at now

Rookietown is now using the proper **96 × 28** layout decoded from the original game data, rather than the earlier guessed version.

A lot of the work so far has been fixing small things that make a big difference when the level is actually running. These are the main parts that are currently working or have had substantial work done:

- corrected Rookietown map layout from the Mega Drive game data
- corrected map decompression
- corrected 16×16 metatile assembly order
- corrected buildings, trees and other asymmetric graphics
- improved AGA palette and transparency handling
- Alex can move left and right and backtrack through the level
- camera movement has been adjusted so going back through an area works properly
- standing, walking, jumping, crawling and punching use ROM-derived animation work
- standing punch and crawling punch are handled separately
- jumping no longer incorrectly drops into the crawl animation
- ROM-derived angel/death sequence work
- enemy collision and punch-to-defeat behaviour
- enemy placement reconstructed from the original object data
- interactive chests
- Alex can walk through the sides of chests but stand on the tops
- chest reward handling
- grey wall collision
- corrected floor collision
- lowered sections of the road can actually be walked down into
- camera/floor framing fixes
- title and intro extraction work
- title-screen flicker and parser fixes

It is **not a complete game yet**. There is still a lot to do, but Stage 1 is now a much better base to build the rest of the port from.

## Progress so far

I have kept the version history below because it gives a useful picture of how the port has developed and also makes it easier to tell when a particular fix was introduced.

| Version / phase | What changed |
|---|---|
| v0.9 | First Rookietown object-coordinate corrections. |
| v1.0 | More object-position alignment fixes. |
| v1.1 | Corrected object origins and spawn positions. |
| v1.4 | Amiga 1200 AGA compiler compatibility work. |
| v1.5 | More AGA build/compiler fixes. |
| v1.6 | Default icon and launch handling fix. |
| v1.9 | ROM palette work. |
| v2.0 | AGA transparency fixes. |
| v2.1 | Rookietown palette correction. |
| v2.2 | First Rookietown tile-order correction. |
| v2.3 | Death-animation work from the original game. |
| v2.4 | Enemy collision and player-death behaviour. |
| v2.5 | Angel death sequence. |
| v2.6 | Crawl-control fixes. |
| v2.7 | Crawl attack-direction/compiler fix. |
| v2.8–v3.0 | Camera framing, parser fixes and floor-graphics corrections. |
| v3.1 | Floor collision pass. |
| v3.2 | Rookietown collision reconstruction. |
| v3.3 | Correct crawl behaviour. |
| v3.4 | Jump and chest collision fixes. |
| v3.5 | One-way chest platform behaviour. |
| v3.6 | Original floor graphics restored. |
| v3.7 | Grey-wall collision. |
| v3.8 | Punch animation/work from the original game. |
| v3.9 | Leftward backtracking and camera fixes. |
| v4.0 | Original title intro integration. |
| v4.1 | Title-screen flicker fixes. |
| v4.2 | Startup parser fix. |
| v4.3 | More title animation/static-title stability work. |
| v4.4 | Enemy punch/kill behaviour. |
| v4.5 / v4.5.1 | Chest rewards and reward corrections. |
| v4.6 | First attempt at restoring the full Rookietown layout. |
| v4.7 | Correct map decoder and full 96×28 layout rebuild. |
| v4.8 | Further graphics tile-order investigation. |
| v4.9 | Scorpion tileset import/GID correction. |
| v5.0 | Fixed building/tree metatile assembly order to **TL, TR, BL, BR**. |
| v5.1 | Changed the main floor to top-surface/platform collision. |
| **v5.2** | **Current stable version.** Lowered road sections are open and walkable with proper lower surfaces. |
| v5.3.x | Building-wall parallax experiments. These were rolled back because they caused regressions elsewhere. |

## A few useful technical notes

### Rookietown map decoding

One of the bigger breakthroughs was working out the actual Rookietown map decoder instead of relying on the earlier guessed format.

The level is **96 metatiles wide and 28 metatiles high**, which works out at **2,688 entries for each map plane**.

The original game uses two compressed map streams. Rebuilding those properly fixed a lot of the layout problems that were present in the earlier versions of the port.

### Metatile order

Another problem that took a while to track down was the order of the four 8×8 pieces inside each 16×16 metatile.

The correct order is:

```text
Top-left     Top-right
Bottom-left  Bottom-right
```

or:

```text
TL, TR, BL, BR
```

Getting this wrong was why things like palm trees, roofs, windows, doors and building edges looked scrambled even though the correct graphics were being used.

### Collision

The current Stage 1 collision setup is roughly:

- normal road surface uses top-only/platform-style collision
- lowered road sections have an open top and a lower walkable floor
- grey walls and boundaries are solid where they need to be
- chests can be passed through from the side but stood on from above

This is much closer to how the original game behaves than the earlier version where large parts of the floor were treated as one solid block.

## Building and running it

1. Clone or download this repository.
2. Run `python3 restore_project.py`.
3. Install a compatible recent **Scorpion Engine / Scorpion Editor 2026.x** build.
4. Open `project.sproject`.
5. Select the **Amiga AGA** target.
6. Build or test Rookietown from there.

## What still needs doing

There is plenty left on the list. The main jobs at the moment are:

- work out the correct building-wall parallax without breaking the working level
- finish the remaining stages after Rookietown
- complete enemy and boss behaviour
- finish game events and interactions
- reproduce more of the original music and sound
- more gameplay polishing and accuracy work
- final Amiga release / WHDLoad packaging

From this point on I want to keep **v5.2 as the known-good baseline** and make changes in smaller isolated steps. A few of the later experiments showed how easy it is to fix one visual effect and accidentally break movement, layering or collision somewhere else.

## ROM and copyright note

This repository does **not** contain a complete Mega Drive ROM.

The port has been developed by analysing the original game and using extracted/reference data where needed. If you are doing your own extraction or verification, you should use a copy of the game that you legally own.

This is a fan-made port/preservation project. It is not affiliated with or endorsed by SEGA.
