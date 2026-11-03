# Setup and local build

## Prerequisites

- Windows and a **separately obtained December 2010 Unreal Development Kit installation**.
- The original Jazz tutorial archive, separately obtained.
- Enough disk space for an installed UDK runtime and asset packages.
- Your own backups of `JazzMiniGame.mobile` and working portable folder.

This repository does **not** include UDK, the original Jazz tutorial, game models/textures/music, or compiled third-party binaries.

## Original project files

The original archive installs these tutorial files relative to the UDK root:

```text
MobileGame/Content/Environments/KismetGame_Assets.upk
MobileGame/Content/Maps/JazzMiniGame.mobile
MobileGame/Content/Maps/KismetTutorial_Final.mobile
MobileGame/Content/Maps/KismetTutorial_Start.mobile
MobileGame/Build/iPhone/Resources/Music/Jazz_Gameplay_01.mp3
MobileGame/Build/iPhone/Resources/Music/Jazz_Menu_01.mp3
```

Some assets, including `Castle_Assets`, `CastleAudio`, and `E3_Demo`, come from the UDK installation rather than the Jazz tutorial archive.

## Run without the editor

From the UDK installation root, launch:

```bat
Binaries\Win32\UDKMobile.exe JazzMiniGame -simmobile -windowed -ResX=1024 -ResY=768 -log
```

You can use `tools/Play_Jazz_Mobile.cmd` instead.

**Do not use `UDK.exe` for this test.** That invokes the desktop configuration and can load the wrong gameplay class and HUD.

## Experimental PC controls

The mod classes are:

```text
Development/Src/JazzPC/Classes/JazzPCController.uc
Development/Src/JazzPC/Classes/JazzPCGame.uc
```

Register script packages in the **UDK installation** `MobileGame/Config/DefaultEngine.ini` under `[UnrealEd.EditorEngine]` in this order, preserving other existing entries:

```ini
+EditPackages=UDKBase
+EditPackages=MobileGame
+EditPackages=JazzPC
```

Use a duplicate `JazzMiniGame_PC.mobile` map and compile locally with the UDK compiler:

```bat
Binaries\Win32\UDKMobile.exe make -log
```

Then launch:

```bat
Binaries\Win32\UDKMobile.exe "JazzMiniGame_PC?game=JazzPC.JazzPCGame" -simmobile -windowed -ResX=1024 -ResY=768 -log
```

The **v4.7 controller is the last verified working WASD baseline**. Do not regard v4.8 mouse support as verified until it compiles and passes tests on Windows.

## Diagnostics

Logs are typically written to `MobileGame/Logs/Launch.log`. Check for:

```text
Game class is 'JazzPCGame'
JazzPC: input bindings installed
JazzPC: found both mobile Kismet look events
JazzPC: ping received
```

Do not publish raw logs without checking for usernames, paths, computer names, network addresses, or other personal data.

## Packaging policy

Only locally copy the licensed UDK runtime and assets. Never push packaged games, `.upk`, `.mobile`, `.u`, or runtime EXEs into this repository. A clean-machine test is still required before declaring the game universally portable.
