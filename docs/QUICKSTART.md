# Quick start for Windows

The repository contains **tools and original community-written UnrealScript only**, not a downloadable game. Use files from your own December 2010 UDK installation and original Jazz tutorial archive.

## 1. Original editor-free game

Use `UDKMobile.exe` rather than `UDK.exe`:

```bat
cd /d C:\UDK\UDK-2010-12
Binaries\Win32\UDKMobile.exe JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
```

The project owner verified that the original Jazz mini-game launches and plays using this path.

## 2. Make the tested portable copy

Copy `tools/Build_Jazz_Portable_v2.cmd` and `tools/Play_Jazz_Portable.cmd` into the **root of your installed UDK directory**, next to `Binaries`, `Engine`, `MobileGame`, and `UDKGame`. Run the builder.

It copies the installed runtime and original assets into a sibling `JazzUDK_Portable` folder. Launch its `Play_Jazz_Portable.cmd`.

This is a local-copy tool, not a package containing the game. The first full copy was around **2.85 GB** on the test system.

## 3. Make the tested slim copy

Copy `tools/Build_Jazz_Slim.cmd` and `tools/Build_Jazz_Slim.ps1` into the **root of the working JazzUDK_Portable folder**, then run the CMD script.

The slim builder creates an independent sibling `JazzUDK_Slim_Test` folder, originally measured at about **970 MB**. Test `Play_Jazz_Slim.cmd` in that new folder. Do not delete the verified original copy.

The script retains all mobile asset packages and the required Win32 runtime. It removes editor autosaves, unrelated sample maps, desktop demo content, and nonessential toolchain directories from the *copy* only.

## 4. Compile the verified WASD controller (v4.7)

On your **full UDK installation**, not on the slim build:

1. Back up `MobileGame/Script/JazzPC.u` if present.
2. Copy `Source/v4.7/JazzPCController.uc` to `Development/Src/JazzPC/Classes/JazzPCController.uc`.
3. Copy `Source/shared/JazzPCGame.uc` to `Development/Src/JazzPC/Classes/JazzPCGame.uc`.
4. In `MobileGame/Config/DefaultEngine.ini` ensure the `[UnrealEd.EditorEngine]` package list compiles `UDKBase`, then `MobileGame`, then `JazzPC`.
5. If necessary to force rebuilding **only the mod**, back up and then remove the old `MobileGame/Script/JazzPC.u`; leave engine packages alone.
6. Run `Binaries/Win32/UDKMobile.exe make -log` locally and verify that `JazzPC` recompiles with zero errors.
7. Use a separately copied `JazzMiniGame_PC.mobile` and launch with `?game=JazzPC.JazzPCGame`.

The tested v4.7 setting is `JazzMovementStrength=120.0`. WASD and diagonals were confirmed working.

## 5. Mouse prototype (v4.8)

`Source/v4.8/JazzPCController.uc` is an **experimental replacement**. Keep the known-good v4.7 source and compiled `JazzPC.u` backed up before replacing them. Rebuild and test separately.

At the time of this README, native left-click firing and cursor aiming have **not** been confirmed working on Windows.

## Do not publish original game files

Do not commit or attach UDK/Jazz `.upk`, `.mobile`, `.u`, `.exe`, audio, or other original proprietary files to this public repository. Check logs for identifying details before sharing diagnostics.
