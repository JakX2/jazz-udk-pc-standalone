# Jazz UDK PC Edition v1.0.0

**Release classification:** first organized **local Windows portable build** of the enhanced 2010 Jazz Jackrabbit UDK demo. It is **not** a public game-binary distribution and is not an official Epic Games release.

**Gameplay baseline:** user-tested [JazzPC v4.8.4](../Source/v4.8.4/JazzPCController.uc), including native WASD movement, hidden original touch-stick artwork and suppressed hidden left touch movement.

## What v1.0 includes

- Standalone editor-free Windows launcher using `Binaries/Win32/UDKMobile.exe`, `-simmobile` and the copied `JazzMiniGame_PC.mobile` map.
- Separate original 2010 demo launcher using `JazzMiniGame.mobile` without selecting `JazzPC.JazzPCGame`.
- The user-tested v4.8.4 compiled controller copied **locally** from the full December 2010 UDK installation, not rebuilt by the v1.0 packager.
- Preserved `KismetGame_Assets.upk`, `Castle_Assets.upk`, `CastleAudio.upk` and `E3_Demo.upk` for sky fidelity.
- Clean release root: `Play Jazz PC.cmd`, `Play Jazz Original.cmd`, `README.txt`, `Tools/` and original engine/game folders.
- Debug launcher, file/hash verifier, release manifest and build log tucked into `Tools/`.

The **direct UDK builder, revision 1.2**, creates a new directory beside the full UDK installation without altering it. No earlier portable folder or portable-build manifest is required. It verifies the installed controller's v4.8.4 feature markers and SHA-256 checks that original/PC maps and the compiled `JazzPC.u` were copied unchanged.

## Build instructions

1. Obtain the **`Jazz_UDK_PC_Edition_v1.0_Direct_UDK_Builder.zip`** source-only ZIP from the development conversation. No original Epic assets or compiled files are distributed with the builder.
2. Have the original December 2010 UDK, Jazz demo files, and a successful local build of `JazzPC v4.8.4` installed. The full SDK must contain the original and copied PC maps and the compiled `MobileGame/Script/JazzPC.u`.
3. Extract the builder ZIP to a normal folder, or to your UDK root; run `Build_Jazz_UDK_PC_v1.0.cmd`. It detects `C:\UDK\UDK-2010-12` or accepts `-UdkRoot`.
4. The builder copies only the runtime/game folders following the previously tested slim-copy recipe. The default output is `C:\UDK\Jazz_UDK_PC_Edition_v1.0`.
5. In the new folder, run `Play Jazz PC.cmd`, then `Play Jazz Original.cmd`.
6. Run `Tools/Verify Jazz PC.cmd` and test F9, WASD, invisible touch joysticks and disabled left movement.

**Recipients of a complete, authorized finished build do not need the earlier portable builds or the UDK editor.** They run the supplied launchers. Runtime prerequisites on a clean PC still need verification.

### Controls (PC mode)

| Key | Behavior |
| --- | --- |
| WASD | Move, including diagonals |
| F9 | Existing Kismet firing bridge |
| Q / E | Rotate aim for testing |
| F10 | Toggle touch-stick graphics |
| F11 | Toggle left touch movement suppression |

**Native cursor aiming and held left-click firing are experimental**, not release promises. Camera modes and an Android port are outside v1.0.

## Verification and limitations

- The original Windows game and v4.8.4 controller behavior were reported working by the project owner.
- **Direct-UDK builder ZIP integrity, source-version markers, structural and static checks passed.**
- **The v1.0 packager and clean-machine portability have not yet been tested end-to-end under Windows.** This is a packaging milestone, not proof of compatibility with every PC.
- Source-only repository. Do not publicly distribute original Epic/UDK binaries, maps, media, or compiled game files without the rights holders' permission.

Next work: complete a Windows v1.0 package test, check F10/F11, inspect clean-machine prerequisites, then advance the native mouse aiming issue separately.

See also [portable builder history](PORTABLE_PC_V484.md), [current status](STATUS.md) and [mouse input issue](https://github.com/JakX2/jazz-udk-pc-standalone/issues/1).
