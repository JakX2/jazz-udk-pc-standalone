# Preservation policy

**Preserve first. Modify second.**

- Store an untouched copy of the original Jazz tutorial ZIP and original UDK installation outside the Git working tree.
- Keep the original `JazzMiniGame.mobile` unchanged; experiment on `JazzMiniGame_PC.mobile`.
- Prefer local scripts with backups and rollback over in-place asset edits.
- Record UDK build (December 2010, Win32), launch arguments, source revisions, asset dependencies and observed test results.
- Never assert that a code change or port is functional until tested in the target runtime.
- Keep original material rendering, music, camera and behavior available even as optional PC enhancements are added.
- Exclude original Epic/third-party asset packages, runtime binaries and media from public source commits.
- Keep generated logs private unless redacted.

## Package decisions from actual tests

| Package | Policy | Reason |
| --- | --- | --- |
| `KismetGame_Assets.upk` | Keep | Core Jazz assets |
| `Castle_Assets.upk` | Keep | Textures broke when removed |
| `CastleAudio` | Keep | Audio dependency references |
| `E3_Demo.upk` | Keep | Sky-mesh reference; fidelity over size |
| `CastleArena_Assets.upk` | Optional exclusion | No observed breakage in user's local test |

These results do not establish a complete dependency graph for every possible scene or state.

## Release separation

**Original Preservation Edition:** untouched map, original mobile UI and gameplay, minimum launcher/build modifications.

**Enhanced PC Edition:** separately versioned `JazzPC` controller, keyboard/mouse work, and eventual camera experiments. Clearly label unverified features.

**Android:** separate research track; the old public December 2010 UDK does not provide a direct modern Android package workflow.
