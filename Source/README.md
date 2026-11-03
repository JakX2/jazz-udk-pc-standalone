# JazzPC UnrealScript

The classes here are **community-authored modifications**, not original Epic source. Use them only with a separately acquired December 2010 UDK installation.

- [v4.7/JazzPCController.uc](v4.7/JazzPCController.uc): **verified WASD movement** (including diagonals), based on `MoveZone` events.
- [v4.8/JazzPCController.uc](v4.8/JazzPCController.uc): experimental simulated-mouse/touch callback. Not verified on the target Windows runtime yet.
- [shared/JazzPCGame.uc](shared/JazzPCGame.uc): selects our controller class.

For UDK compilation, place your chosen controller at `Development/Src/JazzPC/Classes/JazzPCController.uc`, place `JazzPCGame.uc` in the same directory, and register packages after `UDKBase` and `MobileGame`. Use `UDKMobile.exe make -log`.

Never compile both controller versions under the same package at once. Keep your working v4.7 `JazzPC.u` backed up before testing v4.8.
