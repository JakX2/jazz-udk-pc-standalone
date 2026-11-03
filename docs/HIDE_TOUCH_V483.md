# v4.8.3: Optional invisible mobile joysticks

The original *December 2010* `GameFramework.MobileInputZone.uc` exposes `bIsInvisible`. The original `MobileHUD.DrawInputZoneOverlays()` checks `!Zone.bIsInvisible` before drawing a zone.

The [v4.8.3 controller](../Source/v4.8.3/JazzPCController.uc) uses that native **visual-only** setting for the two original Jazz joystick zones, `MoveZone` and `LookZone`.

## Behavior

- **Default in PC edition:** hide the left and right translucent virtual joystick circles.
- **F10:** show/hide them at runtime.
- **Console:** `JazzHideTouchSticks`, `JazzShowTouchSticks`, `JazzToggleTouchSticks`, `JazzTouchSticksStatus`.
- **Kismet, original touch handlers, music, HUD counters and pause menu:** preserved.
- **Original JazzMiniGame map:** not modified. The mod is only loaded in the alternate `JazzMiniGame_PC` game mode.

The controller periodically reapplies the flag because Kismet can initialize input zones after the controller is created.

## Installation

The full installer/compilation ZIP is distributed through the development conversation under `JazzUDK_PC_HideTouch_v4_8_3.zip`.

Extract it into the full `C:\UDK\UDK-2010-12` installation and run `InstallAndBuild_JazzPC_HideTouch_v4_8_3.cmd`.

The tool validates its source checksum, backs up the existing JazzPC controller and compiled package, recompiles using `UDKMobile.exe make`, and attempts to restore the previous source and compiled mod package on failure. It does not change Epic original assets, maps, or packaged preservation edition.

## Test

Launch your experimental `Play_Jazz_PC_v4.cmd` after successful compilation.

1. Confirm the two virtual joystick images are gone.
2. Confirm health, score, pause icon, WASD, diagonal movement, and F9 shooting still work.
3. Press F10 to show both circles, and again to hide.
4. Run `JazzTouchSticksStatus` to log the two input-zone references and actual flags.
5. If the images remain, inspect `MobileGame/Logs/Launch.log` for `JazzPC TOUCH:` lines.

**Build status:** static source and ZIP integrity checked. *Not yet compiled or runtime-tested under December 2010 UDK.* Keep v4.8.2 / working preservation builds available for rollback.

Original UE3/UDK assets and compiled proprietary binaries must not be committed to the public repository.
