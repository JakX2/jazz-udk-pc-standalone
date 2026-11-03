# JazzPC v4.8.2: safe forced recompilation

If the old `Compile_JazzPC_v4_8_1.cmd` says **“JazzPC.u still exists”**, this is *not* a new compiler failure. The old v4.8.1 wrapper intentionally refuses to compile over an existing package, and the v4.8.2 corrected-source installer deliberately does not touch that compiled package.

**Do not rerun v4.8.1 installation or blindly delete `JazzPC.u`.** First close the game and editor. Use the standalone **v4.8.2 safe rebuild helper** supplied with its PowerShell script. Extract the CMD to the UDK root and the PS1 to `Tools/`, then run `Rebuild_JazzPC_v4_8_2_SAFE.cmd`.

The helper verifies the corrected v4.8.2 source checksum, makes a timestamped backup of the previous compiled package, removes only that mod package to force the engine to compile, runs `UDKMobile.exe make` without `-log`, inspects the new package and compilation output, and restores the previous package automatically on failure.

The full PowerShell script is [here](../tools/v4.8.2/Rebuild_JazzPC_v4_8_2_SAFE.ps1). Full project/repository source is optional; do **not** upload copyrighted UDK binary packages or game assets. Last verified controller remains **v4.7**, and v4.8.2 mouse behavior is still experimental.

Check the compiler log for `JazzPC - Release` and `Success - 0 error(s)`. After a successful compile, launch the separate PC test map and verify WASD and F9 before mouse aiming experiments.

## If manually rebuilding

Only if you know how to restore from backups: copy `MobileGame/Script/JazzPC.u` to a safe location, verify its copy, remove the original from the `Script` folder, run `Binaries/Win32/UDKMobile.exe make`, and restore the original `JazzPC.u` if the corrected source does not compile. Never modify `.mobile` or `.upk` files to address this message.
