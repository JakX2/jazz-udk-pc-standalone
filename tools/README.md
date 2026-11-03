# Local helpers

Tools in this folder are **source-only**. Use them with your own locally installed December 2010 UDK and Jazz tutorial files.

**The vintage helper scripts were originally designed to be placed in the root of the UDK installation or working portable build.** When using `Build_Jazz_Slim.ps1` or `Compile_JazzPC_v4_*.cmd`, first copy the script to that root; do not execute it in-place from a Git checkout.

- `Play_Jazz_Mobile.cmd`: convenience launch (runs from the `tools` subfolder copied beneath a UDK root).
- `Play_Jazz_PC.cmd`: experimental PC controller launch (same placement).
- `Build_Jazz_Slim.ps1`: tested conservative copy procedure. Copy this script into the **working portable folder** before running it. It keeps original assets and creates an independent sibling `JazzUDK_Slim_Test` directory.
- `Compile_JazzPC_v4_7.cmd`: local compiler wrapper for the known-good controller. Copy to UDK root.
- `Compile_JazzPC_v4_8.cmd`: cautious experimental compiler wrapper. Copy to UDK root; ensure the working `JazzPC.u` was backed up before attempting an experiment.

The helpers do not contain Epic assets, compiled scripts or Unreal executables. Never commit local logs, paths or built copies. The standalone game's true portability still needs a clean-machine validation.
