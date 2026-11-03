# JazzPC v4.8.4: Local portable builder

**Status:** Source-only builder ZIP created; full Windows run still needs testing. The project does not distribute Epic game assets, UDK binaries, or compiled proprietary packages.

The builder starts from two existing LOCAL folders:

- Full December 2010 UDK installation, typically C:\UDK\UDK-2010-12, where JazzPC v4.8.4 is already compiled and works.
- Working JazzUDK_Slim_Test portable copy, approximately 970 MB in the owner's earlier test.

It requires the PC map JazzMiniGame_PC.mobile and compiled JazzPC.u from the full UDK. It verifies v4.8.4 source markers, copies the slim folder into a separate JazzUDK_PC_Portable_v484 folder, and injects those two mod files locally. The original JazzMiniGame.mobile is retained.

It preserves KismetGame_Assets.upk, Castle_Assets.upk, CastleAudio.upk, and E3_Demo.upk (sky); missing copies can be recovered from the local UDK installation. It writes a manifest containing the hashes of locally copied compiled script and PC map, and provides Play_Jazz_PC.cmd, Play_Jazz_Original.cmd, and Verify_Jazz_PC.cmd.

## Quick start

1. Keep a backup of the successful v4.8.4 compiled controller and the working slim build.
2. Extract the source-only JazzUDK_PC_Portable_Builder_v1.zip provided in the development conversation to any normal folder (not inside UDK).
3. Run Build_Jazz_PC_Portable.cmd and provide folder locations if prompted.
4. Launch Play_Jazz_PC.cmd from the newly created folder. Test WASD, firing, hidden joystick art and disabled left touch movement.
5. Launch Play_Jazz_Original.cmd to verify the original 2010 mode still works.
6. Check JazzPC_Portable_Build.log after any copy/build failure.

The builder never edits or deletes source UDK/slim folders. It does not compile code, and it creates a new numbered folder if a prior output already exists.

## Known limitations

- Native mouse aiming and held left-click firing remain experimental.
- Third-person camera remains unimplemented.
- The script itself still needs a Windows execution test.
- Running outside the editor on the original developer PC is verified; a second clean Windows PC still needs a full portability check.
- The locally generated output contains third-party UDK/Jazz assets. Do not publicly redistribute without permission.

Related: [v4.8.4 controller source](../Source/v4.8.4/JazzPCController.uc), [status](STATUS.md), and [touch movement filter](BLOCK_TOUCH_V484.md).
