# v4.8.2: Full-source installer replacement

The original patch script tried to match *five exact snippets* in the currently installed controller. If four fixes were already present and an unused assignment had already been removed, it would abort with `Unexpected source contents` instead of succeeding.

The replacement is a **full-controller copy**, not a text-substitution patch. It is idempotent, validates the bundled source's checksum, backs up the currently installed `.uc` file before replacement, and does not touch original assets, maps, or `JazzPC.u`.

For the preassembled ZIP, use [the conversation download](https://github.com/JakX2/jazz-udk-pc-standalone/blob/main/docs/TEST_V481.md) and follow its README. The installer expects its bundled `JazzPCController_v4_8_2.uc` alongside the two installer scripts in the UDK installation root. When building from GitHub, ensure the bundle exactly matches the SHA-256 encoded in the installer; GitHub's standalone source copy may differ by release-specific metadata/formatting and should not be mixed casually with a prepackaged installer.

Run `Install_JazzPC_v4_8_2_FIXED.cmd`, then compile `JazzPC` only if the compiled package is missing or you have separately backed it up before a forced build.

The change only repairs three `vector2D` log concatenations and removes the unused `MouseDY` declaration and assignment. Gameplay behavior is unchanged; Windows compilation and mouse behavior require separate testing.
