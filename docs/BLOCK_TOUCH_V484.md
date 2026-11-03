# JazzPC v4.8.4: Disable invisible left-stick movement

**Status:** experimental. Source reviewed against the original December 2010 UDK `GameFramework.MobileInputZone` API and ZIP structure tested, but compilation and runtime behavior require a Windows test.

## Why

v4.8.3 successfully hid the virtual joystick artwork via `bIsInvisible`. The original left joystick (`MoveZone`) still processed touches, which is undesirable for an enhanced PC interface.

## Approach

v4.8.4 builds directly on [v4.8.3](../Source/v4.8.3/JazzPCController.uc) and registers a handler for **only** `MoveZone.OnProcessInputDelegate`. In the original API, returning `true` swallows touch processing for that zone. The filter still permits touch-release and cancel events to avoid leaving a previously active drag stuck.

The existing keyboard movement code sends values to Kismet's `MoveZone` event directly with `PulseMobileLook`, bypassing native touch processing. Therefore WASD movement is intended to remain functional.

The right `LookZone`, original audio, HUD, pause button, animations, shooting system, and unchanged `JazzMiniGame.mobile` are outside this patch.

## Controls

| Input | Intended behavior |
| --- | --- |
| WASD | Move Jazz, diagonals included |
| Invisible left touch zone | Movement blocked by default |
| F11 | Toggle left touch movement on/off |
| F10 | Toggle joystick visibility on/off |
| `JazzDisableTouchMovement` | Block left zone input |
| `JazzEnableTouchMovement` | Allow the original left touch zone input |
| `JazzTouchMovementStatus` | Write zone/hook state and swallowed touch count to runtime log |

## Installation

Use the separate `JazzUDK_PC_DisableTouchMove_v4_8_4.zip` test package from the development conversation. It contains source, a staged installer, direct UDK compiler script and exact rollback.

1. Close all Jazz/UDK windows and keep your working v4.8.3 build.
2. Extract into the full December 2010 UDK root.
3. Run `Stage_DisableTouchMove_v4_8_4.cmd`. It backs up the previous `.uc` and `JazzPC.u` before staging the change.
4. Run `Compile_DisableTouchMove_v4_8_4_Direct.cmd`. It invokes `UDKMobile.exe make -log` directly, avoiding the old PowerShell process-wait timeout.
5. Confirm compilation of `JazzPC` has zero errors and a fresh `MobileGame/Script/JazzPC.u`.
6. Launch the copied `JazzMiniGame_PC.mobile` test map using the custom JazzPC game class.

If compilation or gameplay fails, close UDK and run `Restore_DisableTouchMove_v4_8_4.cmd`. Original `.mobile` / `.upk` assets are never modified by these scripts.

## Required tests

- [ ] WASD and diagonals still move Jazz.
- [ ] Clicking and dragging at the invisible left-stick position **does not** move Jazz.
- [ ] `JazzTouchMovementStatus` confirms a hooked `MoveZone` and logs swallowed touches.
- [ ] F11 turns touch movement back on, then blocks it again.
- [ ] F10 still shows/hides joystick images.
- [ ] Right look input, F9 firing, pause, health and score remain as before.
- [ ] Rollback restores previously working controller and compiled package.

**No claim of successful runtime blocking is made until the owner verifies it.**
