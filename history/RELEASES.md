# Development history

These were iterative local experiments, **not** public binary releases. Old helper archives were shared during development but are not all reproduced here. The repository prioritizes reproducible source and working techniques, not every unsuccessful launcher.

| Version | Outcome |
| --- | --- |
| Runtime v1-v2 | Desktop `UDK.exe` was the wrong game context: map resolution problems and wrong HUD. |
| Runtime v3 | Correct launch via `UDKMobile.exe` and `-simmobile`. Tested. |
| Portable v1 | First copy procedure failed. |
| Portable v2 | Working portable Windows copy; ~2.85 GB before trimming. |
| Slim builder v1 | Working ~970 MB copy. |
| Input v1-v3 | Explored keyboard bindings and Kismet input events. |
| Native v4 | Custom UnrealScript controller; initial install/compile issues. |
| v4.1 | Fixed PowerShell path handling. |
| v4.2 | Corrected UnrealScript compilation order: UDKBase, MobileGame, JazzPC. |
| v4.3 | Fixed `SetBind` argument requiring a key-name variable. |
| v4.4 | Verified game class, controller, Kismet event discovery and ping via runtime log. |
| v4.5-v4.6 | Diagnosed controller movement and forced script recompilation. |
| **v4.7** | **Verified WASD movement** by applying suitable MoveZone strength (default 120). |
| **v4.8** | **Experimental mouse input** via MobilePlayerInput touch callback, awaiting a Windows compile and gameplay test. |

## Lessons learned

- Verify generated packages by examining runtime logs, not merely process exit codes.
- `make` may say “No scripts need recompiling”; source installation and compiled-package freshness must be checked independently.
- `SetBind` cannot take key literals in this UDK version.
- A joystick `StickStrength` of 1.0 was insufficient for Jazz's original movement graph; scaling it solved the verified WASD problem.
- A successful `causeevent` projectile test does not prove the mouse button is reaching Kismet.
- Preserve the known-good controller and original map before each experiment.

No claim is made that experimental versions are stable.
