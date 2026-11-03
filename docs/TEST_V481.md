# JazzPC v4.8.1: mouse bridge diagnostic (experimental)

**Not yet compiled/tested on the original December 2010 Windows UDK runtime.** The last confirmed working controller remains **v4.7** (WASD and diagonal movement).

v4.8.1 keeps the v4.8 `MobilePlayerInput.OnInputTouch` experiment and adds `JazzMouseSimDown` / `JazzMouseSimUp`, which create a **synthetic** test trigger with a chosen cursor position. This isolates original Kismet `LookZone` firing from actual Windows mouse-to-touch event delivery.

## Install (full UDK editor installation only)

The ready-to-extract ZIP is supplied through the development conversation. To install manually from this repository:

1. Back up `MobileGame/Script/JazzPC.u` and `Development/Src/JazzPC/Classes/JazzPCController.uc` and close all UDK windows.
2. Copy [JazzPCController.uc](../Source/v4.8.1/JazzPCController.uc) into your UDK as `Source/JazzPCController_v4_8_1.uc` (temporary input for the installer).
3. Copy scripts from [tools/v4.8.1](../tools/v4.8.1/) into the UDK root: the `.cmd` files at the UDK root and the `.ps1` files in its `Tools/` subfolder.
4. Run `Install_JazzPC_Mouse_v4_8_1.cmd`. It checks expected classes, saves a timestamped controller + compiled package backup, then replaces only the experimental controller and removes `JazzPC.u` to force recompilation.
5. Run `Compile_JazzPC_v4_8_1.cmd`. In `MobileGame/Logs/Launch.log`, verify `JazzPC - Release` and `Success - 0 error(s), 0 warning(s)`.
6. Launch your copied `JazzMiniGame_PC.mobile` map with `?game=JazzPC.JazzPCGame`.

Never overwrite `JazzMiniGame.mobile`, original Epic assets, or your working preservation build.

## Gameplay tests

First test that **WASD**, diagonal movement, Q/E, and F9 are not broken.

Then enable diagnostics:

```text
JazzMouseStatus
JazzMouseDebugOn
JazzMouseModeOn
```

Close the console, **press and drag left-click** over the game, release, exit, and inspect `MobileGame/Logs/Launch.log` for `JazzPC MOUSE:` lines.

### If real clicks aren't detected, test the Kismet path separately

```text
JazzMouseModeOn
JazzMouseSimDown 0.8 0.5
```

Close the console. This *synthetically* holds the aim/fire input in the direction of a screen point (80% right, 50% down). **Always release the test input**:

```text
JazzMouseSimUp
```

Expected interpretations:

| Real click | Synthetic test | Likely next investigation |
| --- | --- | --- |
| Fires and aims | Fires and aims | Calibrate direction, screen origin, stopping behavior, weapon modes |
| No response | Fires and aims | `-simmobile` is not delivering mouse input to the installed delegate |
| No response | No response | Kismet `LookZone` event activation or controller setup |
| No response | Not tested | Insufficient evidence; run synthetic test |

These are diagnostic leads, not definitive proof of a particular engine bug. Avoid posting unredacted logs.

## Recovery

`JazzMouseModeOff` disables the experimental interpretation while the game is running. To restore the exact previous controller source and package, close Jazz/UDK and run `Restore_JazzPC_Pre_v4_8_1.cmd`.

The backup restores whatever controller was installed immediately **before** v4.8.1. If that was v4.8, you will get v4.8 back; it is not an automatic v4.7 downgrade.

## Current limitations

- The 2010 `OnInputTouch` delegate signature has four parameters (confirmed in original `MobilePlayerInput.uc`). Later UDK builds use a different signature.
- Touch callbacks might not include mouse movement while hovering.
- Aim origin currently uses a configurable screen center, not Jazz's projected actor position.
- Click handling is observational; the original simulator can still act on the same touch.
- No third-person camera or Android build is included.

**Build status:** static source/ZIP checks passed; target UDK compilation and gameplay tests pending.
