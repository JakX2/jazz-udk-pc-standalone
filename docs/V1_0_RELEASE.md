# Jazz UDK PC Edition v1.0.0

**Release classification:** first organized **local Windows portable build** of the enhanced 2010 Jazz Jackrabbit UDK demo. It is **not** a public game-binary distribution and is not an official Epic Games release.

**Gameplay baseline:** user-tested [JazzPC v4.8.4](../Source/v4.8.4/JazzPCController.uc), including native WASD movement, hidden original touch-stick artwork and suppressed hidden left touch movement.

## What v1.0 includes

- Standalone editor-free Windows launcher using `Binaries/Win32/UDKMobile.exe`, `-simmobile` and the copied `JazzMiniGame_PC.mobile` map.
- Separate original 2010 demo launcher using `JazzMiniGame.mobile` without selecting `JazzPC.JazzPCGame`.
- The verified v4.8.4 compiled controller copied **locally** from the user's working portable directory, not rebuilt by the v1.0 packager.
- Preserved `KismetGame_Assets.upk`, `Castle_Assets.upk`, `CastleAudio.upk` and `E3_Demo.upk` for sky fidelity.
- Clean release root: `Play Jazz PC.cmd`, `Play Jazz Original.cmd`, `README.txt`, `Tools/` and original engine/game folders.
- Debug launcher, file/hash verifier, release manifest and legacy launchers tucked into `Tools/`.

The builder creates a **new sibling directory**, never edits the previously working source portable folder, and refuses to label a build v1.0 unless the source's v4.8.4 manifest exists and its stored hashes match `JazzPC.u` and `JazzMiniGame_PC.mobile`.

## Build instructions

1. Use the `Jazz_UDK_PC_Edition_v1.0_Builder.zip` source-only ZIP delivered in the development conversation. It contains PowerShell and CMD scripts, launchers, release text, and a syntax preflight.
2. Extract the ZIP to a separate normal folder.
3. Run `Build_Jazz_UDK_PC_v1.0.cmd`.
4. Choose your already-working `JazzUDK_PC_Portable_v484` folder when prompted; the build requires its `JazzPC_Portable_Manifest.json` from the preceding v1.1 portable builder.
5. In the generated `Jazz_UDK_PC_Edition_v1.0`, run `Play Jazz PC.cmd`, then `Play Jazz Original.cmd`.
6. Run `Tools/Verify Jazz PC.cmd` and check F9 firing, WASD, invisible touch joysticks and suppressed left touch movement.

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
- **ZIP content, source version markers and structural checks passed.**
- **The v1.0 packager and clean-machine portability have not yet been tested end-to-end under Windows.** This is a packaging milestone, not proof of compatibility with every PC.
- Source-only repository. Do not publicly distribute original Epic/UDK binaries, maps, media, or compiled game files without the rights holders' permission.

Next work: complete a Windows v1.0 package test, check F10/F11, inspect clean-machine prerequisites, then advance the native mouse aiming issue separately.

See also [portable builder history](PORTABLE_PC_V484.md), [current status](STATUS.md) and [mouse input issue](https://github.com/JakX2/jazz-udk-pc-standalone/issues/1).
