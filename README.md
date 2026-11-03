# Jazz Jackrabbit UDK (2010) — PC Standalone Preservation

Unofficial community preservation and PC compatibility work for Epic Games' **Jazz Jackrabbit UDK / iOS tech demo (December 2010)**.

The project aims to keep the **original Unreal Engine 3 gameplay, art, music, Kismet logic, and mobile rendering** intact, while making it easier to run on modern Windows PCs and adding optional keyboard/mouse controls.

> **Independent fan preservation project.** Not affiliated with or endorsed by Epic Games. Jazz Jackrabbit, Unreal Engine, UDK and the original game content belong to their respective owners. This repository deliberately does **not** include Epic's original maps, asset packages, music, UDK runtime, or compiled game binaries.

## What works

| Feature | Status |
| --- | --- |
| Original `JazzMiniGame.mobile` playable in UDK Mobile Previewer | Verified |
| Editor-free Windows launch with `Binaries\Win32\UDKMobile.exe` and `-simmobile` | Verified |
| Separate portable Windows folder | Tested by project owner |
| Slim portable build (~970 MB in the tested setup) | Tested by project owner |
| Original ES2 textures and enemy materials | Verified |
| Custom `JazzPC` UnrealScript game/controller | Compiled and loaded successfully |
| WASD movement, including diagonals | **Working in v4.7** |
| Console-triggered shooting | Working |
| Mouse aiming and held left-click firing (v4.8) | **Experimental; unverified** |
| Third-person camera | Not implemented |
| Native Android port | Not implemented |

## Basic launch (with your own licensed/local UDK files)

This is the **known working** launch route for the December 2010 UDK installed at `C:\UDK\UDK-2010-12`:

```bat
@echo off
cd /d "C:\UDK\UDK-2010-12"
"Binaries\Win32\UDKMobile.exe" JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
```

The project's companion launcher uses the same mobile executable, **not** `UDK.exe`. Running the latter may select the wrong desktop game/HUD.

For experimental PC input mods, launch the separately copied map:

```bat
"Binaries\Win32\UDKMobile.exe" "JazzMiniGame_PC?game=JazzPC.JazzPCGame" -simmobile -windowed -ResX=1024 -ResY=768 -log
```

The custom game/controller requires the compiled `JazzPC.u` in your **local** UDK installation.

## Repository layout

- `docs/`: status, setup, preservation notes and troubleshooting.
- `Source/`: original *mod-authored* UnrealScript source, not Epic game source.
- `tools/`: optional local build and installation helpers.
- `history/`: selected version notes and experiments.

The working original files should always be retained separately. **Never replace or distribute the original game archives as part of a test patch.**

## Known asset dependencies

From the tested portable build:

- **Keep** `KismetGame_Assets.upk`, `Castle_Assets.upk`, and `CastleAudio`.
- **Keep** `E3_Demo.upk` for fidelity; the map has a sky-mesh reference.
- `CastleArena_Assets.upk` was excluded without observable gameplay problems in local testing.
- Removing `Castle_Assets.upk` breaks environment textures.

Treat these as test observations, **not** a complete static dependency audit of all UE3 packages.

## Status and next steps

1. Preserve the verified v4.7 WASD controller as the stable baseline.
2. Compile/test v4.8 mouse callbacks without breaking v4.7.
3. Add full held-click firing, mouse aiming and eventually optional third-person camera.
4. Verify the portable game on a clean Windows installation and document runtime prerequisites.
5. Explore Android only as a separate, longer-term porting effort.

See [docs/SETUP.md](docs/SETUP.md) and [docs/STATUS.md](docs/STATUS.md).

## Legal and distribution

This repository contains only community-written tooling and documentation. Obtain the original game/UDK content separately and observe any applicable licenses and copyright restrictions. Do not commit `.upk`, `.mobile`, `.udk`, `.u`, `.exe`, proprietary media, compiled builds, logs, or personal configuration backups.

No public playable-game download is provided here.
