# Verified milestones and experiments

Last updated: 2026-11-03.

| Stage | Finding | Verification |
| --- | --- | --- |
| Original tutorial recovery | `JazzMiniGame.mobile`, `KismetGame_Assets.upk`, music, tutorial maps present | Inspected local archive |
| Desktop UDK editor | Jazz loaded; enemy materials appeared black in normal DX9 rendering | Observed |
| Mobile Previewer | Correct original ES2 materials, enemies, HUD, and gameplay | **User tested** |
| Runtime launch v3 | `UDKMobile.exe JazzMiniGame -simmobile` runs the game without the editor | **User tested** |
| Portable builder v2 | Self-contained directory built; first size about 2.85 GB | **User tested**; clean Windows PC not tested |
| Slim builder v1 | Working copy reduced to about 970 MB | **User tested** |
| Optional package test | `CastleArena_Assets.upk` not needed for observed gameplay | **User tested** |
| Castle package test | Removing `Castle_Assets.upk` broke textures | **User tested** |
| E3 package test | Game remained playable without `E3_Demo.upk`; kept for sky fidelity | Partial visual check |
| PC input early versions | Kismet `MoveZone`, `LookZone` identified, `causeevent` can trigger projectiles | **User tested** |
| JazzPC compile v4.3 | Custom `JazzPC.u` built successfully | **Compiler log** |
| JazzPC runtime v4.4 | `JazzPCGame` loaded, custom controller initialized, Kismet nodes found, `JazzPCPing` reached log | **Runtime log** |
| v4.5 movement diagnostics | Direction/state output reached Kismet but `StickStrength=1.0` did not visibly move Jazz | **User logs** |
| v4.7 movement | Raising MoveZone strength (default 120) enabled WASD in all directions including diagonals | **User tested** |
| v4.8 mouse controls | Experimental mobile touch callback bridge | **Not yet tested / unverified** |
| Third-person camera | Planned optional feature | Not implemented |
| Android port | Feasibility research only | Not implemented |

## Engineering notes

- The working custom controller derives from `MobilePC` and the game class from `MobileGame`, so compile packages in order: `UDKBase`, `MobileGame`, then `JazzPC`.
- In this old engine's `SetBind` API, the key parameter requires a `name` variable rather than a literal.
- `MoveZone` and `LookZone` are exposed through `SeqEvent_MobileLook`; the mod stimulates their existing Kismet outputs.
- The mobile HUD may hide `ClientMessage`; for diagnostics check `MobileGame\Logs\Launch.log`.
- `UDKMobile.exe` is required for the verified ES2 simulation path. `UDK.exe` is not an equivalent replacement.
- The input system in v4.8 has **not** been validated; preserve v4.7 until it is.

## Scope and caveats

The prototype is a historical UDK mobile demonstration, not the cancelled Unreal Engine 1 *Jazz Jackrabbit 3D*. This repository is a compatibility/preservation effort for the **2010 mobile demo**. All size values are measurements from one developer setup, not guaranteed release sizes.
